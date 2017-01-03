//
//  FeedVC
//  Yang
//
//  Created by Biggie Smallz on 2/12/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "FeedVC.h"
#import "PostVC.h"
#import "DateTools.h"
#import "SendKarmaVC.h"
#import "YUtil.h"
#import "UserProfileVC.h"

@implementation FeedVC
@synthesize outstandingQueries;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.outstandingQueries = [NSMutableDictionary dictionary];
        self.parseClassName = kPostClassKey;
        self.pullToRefreshEnabled = NO;
        self.paginationEnabled = YES;
        self.objectsPerPage = 30;
        self.quickEnabled = YES;
    }
    return self;
}

#pragma mark - StatusBar

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.separatorInset = UIEdgeInsetsMake(0, 8, 0, 8);
    self.tableView.separatorColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PostCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.navigationController.hidesBarsOnSwipe = NO;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.translucent = NO;
    
    if (self.quickEnabled) {
        self.quickRefresh = [[YangRefresh alloc] initWithType:JHRefreshControlTypeSlideDown];
        __weak id weakSelf = self;
        [self.quickRefresh addToScrollView:self.tableView withRefreshBlock:^{
            [weakSelf tableViewWasPulledToRefresh];
        }];
    }
    
    // media screen
    
    self.mediaScreen = [[MediaScreenOverlayVC alloc] init];
    
    CGRect frame = self.view.bounds;
    frame.origin.y = CGRectGetHeight(self.view.bounds) + 20;
    frame.size.height += 20;
    
    self.topWindow = [[UIWindow alloc] initWithFrame:frame];
    self.topWindow.windowLevel = UIWindowLevelStatusBar;
    
    [self.topWindow setRootViewController:self.mediaScreen];
    [self.topWindow setHidden:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChangedPostAttr:) name:YPostVCUserUpvotePostNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChangedPostAttr:) name:YUtilUserUpvotePostCallbackFinishedNotification object:nil];
    
    [self setNeedsStatusBarAppearanceUpdate];

}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self clear];
}

-(void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    if (self.quickEnabled) {
        [self.quickRefresh endRefreshing];
    }
    
    if (self.scrollToTop) {
        self.scrollToTop = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });
    }
}

-(void)tableViewWasPulledToRefresh {
    [self loadObjects];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YPostVCUserUpvotePostNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YUtilUserUpvotePostCallbackFinishedNotification object:nil];
}

- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, 20000.0f);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {

    PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:kActivityClassKey];
    [followingActivitiesQuery whereKey:kActivityTypeKey equalTo:kActivityTypeFollow];
    [followingActivitiesQuery whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
    followingActivitiesQuery.cachePolicy = kPFCachePolicyNetworkOnly;
    
    PFQuery *postsFromFollowedUsersAsSenders = [PFQuery queryWithClassName:kPostClassKey];
    [postsFromFollowedUsersAsSenders whereKey:kPostSenderKey matchesKey:kActivityToUserKey inQuery:followingActivitiesQuery];

    PFQuery *postsFromFollowedUsersAsReceivers = [PFQuery queryWithClassName:kPostClassKey];
    [postsFromFollowedUsersAsReceivers whereKey:kPostReceiverKey matchesKey:kActivityToUserKey inQuery:followingActivitiesQuery];

    PFQuery *postsFromFollowedUsers = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:postsFromFollowedUsersAsSenders, postsFromFollowedUsersAsReceivers, nil]];
    
    PFQuery *postsFromCurrentUserAsSender = [PFQuery queryWithClassName:kPostClassKey];
    [postsFromCurrentUserAsSender whereKey:kPostSenderKey equalTo:[PFUser currentUser]];

    PFQuery *postsFromCurrentUserAsReciever = [PFQuery queryWithClassName:kPostClassKey];
    [postsFromCurrentUserAsReciever whereKey:kPostReceiverKey equalTo:[PFUser currentUser]];

    PFQuery *postsFromCurrentUser = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:postsFromCurrentUserAsSender, postsFromCurrentUserAsReciever, nil]];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:postsFromFollowedUsers, postsFromCurrentUser, nil]];
    [query includeKey:kPostSenderKey];
    [query includeKey:kPostReceiverKey];
    [query orderByDescending:@"createdAt"];
    
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    return query;
}

- (PFTableViewCell *)tableView:(UITableView *)otherTableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    
    PFTableViewCell *cell = [super tableView:otherTableView cellForNextPageAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setFont:[UIFont fontWithName:@"OpenSans" size:16.0f]];
    cell.textLabel.text = @"Load more";
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    PostCell *cell = (PostCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell configureCell:cell forObject:object withIndexPath:indexPath withDelegate:self];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:[self _indexPathForPaginationCell]]) {
        return 60.0f;
    } else {
        return [YUtil calcHeight:[self objectAtIndexPath:indexPath] withFrame:self.view.frame];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:[self _indexPathForPaginationCell]]) {
        return 60.0f;
    } else {
        return [YUtil calcHeight:[self objectAtIndexPath:indexPath] withFrame:self.view.frame];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PFObject * post = [self objectAtIndexPath:indexPath];
    
    if (![indexPath isEqual:[self _indexPathForPaginationCell]]) {
        if (post[@"photo"]) {

            self.mediaScreen.post = post;
            [self.mediaScreen show];
            
        } else if (post[@"video"]) {
            
            self.mediaScreen.post = post;
            [self.mediaScreen show];
            
        } else {
            // do nothing...
            
            /*
             PostVC *vc = [[PostVC alloc] initWithPFObject:post withHeight:[YUtil calcHeight:post withFrame:self.view.frame] userDidTapCommentButton:NO];
            [self.navigationController pushViewController:vc animated:YES];
             */
        }
    }
}

#pragma mark - PostCellDelegate

-(void)didTapUpvoteButton:(UIButton *)button forPostCell:(PostCell *)postCell  forPost:(PFObject *)post {
    
    [button setUserInteractionEnabled:NO];
    if (!button.isSelected) {
        BOOL upvoted = !button.selected;
        [postCell setUpvoteStatus:upvoted];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        
        NSNumber *upvotes = [numberFormatter numberFromString:[self normalize:button.titleLabel.text]];
        
        upvotes = [NSNumber numberWithInt:[upvotes intValue] + 1];
        [[YCash sharedCache] incrementUpvoterCountForPost:post];
        
        [[YCash sharedCache] setCurrentUserGaveUpvoteForPost:post upvoted:upvoted];
        
        [YUtil upvotePostInBackground:post block:^(BOOL succeeded, NSError *error) {
            [button setUserInteractionEnabled:YES];
        }];
    } else {
        [button setUserInteractionEnabled:YES];
        // show who up'd
        ShowUpdVC * su = [[ShowUpdVC alloc] initWithPFObject:post];
        [self.navigationController pushViewController:su animated:YES];
    }
}


-(NSString*) normalize: (NSString *) number{
    NSMutableCharacterSet *nonNumberCharacterSet = [NSMutableCharacterSet decimalDigitCharacterSet];
    [nonNumberCharacterSet invert];
    
    return [[number componentsSeparatedByCharactersInSet:nonNumberCharacterSet] componentsJoinedByString:@""];
}

#pragma mark - ProPicDelegate

-(void)didTapUserPic:(ProPicIV *)thePic {
    UserProfileVC *upvc = [[UserProfileVC alloc] initWithUser:thePic.theUser];
    [self.navigationController pushViewController:upvc animated:YES];
}

#pragma mark - NSNotifications

- (void)userChangedPostAttr:(NSNotification *)note {
    [self.tableView reloadData];
}

- (NSIndexPath *) _indexPathForPaginationCell {
    return [NSIndexPath indexPathForRow:[self.objects count] inSection:0];
}


@end
