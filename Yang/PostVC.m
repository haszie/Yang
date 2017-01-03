//
//  PostVC.m
//  Yang
//
//  Created by Biggie Smallz on 2/9/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "PostVC.h"
#import "ProPicIV.h"
#import "UserProfileVC.h"

@interface PostVC () {
    PFObject *post;
    CGFloat cell_height;
    NSMutableArray<PFObject *> *_mutableObjects;
    BOOL scrollToLast;
}

@end

@implementation PostVC
@synthesize outstandingQueries;

- (id)initWithPFObject: (PFObject *) obj withHeight: (CGFloat) height  {
    self = [super init];
    if(self) {
        post = obj;
        cell_height = height;
        _mutableObjects = [NSMutableArray array];
        outstandingQueries = [NSMutableDictionary dictionary];
        scrollToLast = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 8, 0, 8);
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:@"PostVCUpCell"];

    [post fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            
            [post[@"giver"] fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                if (!error) {
                    [post[@"taker"] fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                        [self loadObjects];
                        
                        PostCell *cell = (PostCell *) [[[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil] firstObject];
                        [cell setFrame:CGRectMake(0, 0, self.view.frame.size.width, cell_height)];
                        
                        [cell configureCell:cell forObject:post withDelegate:self];
                        cell.bg.layer.shadowColor = [UIColor clearColor].CGColor;
                        
                        self.tableView.tableHeaderView = cell;
                    }];
                }
            }];
        }
    }];
    
    
    PFFile *propic = [[PFUser currentUser] objectForKey:kUserProfilePicture];
    
    if (self.addMenuButton) {
        UIImage *menu_img = [UIImage imageNamed:@"menu-alt"];
        CGRect menu_frame = CGRectMake(0, 0, 22, 22);
        
        UIButton *menu_btn = [[UIButton alloc] initWithFrame:menu_frame];
        [menu_btn addTarget:self action:@selector(menuButtonPress) forControlEvents:UIControlEventTouchUpInside];
        [menu_btn setImage:menu_img forState:UIControlStateNormal];
        
        UIBarButtonItem *menu_itm= [[UIBarButtonItem alloc] initWithCustomView:menu_btn];
        
        self.navigationItem.leftBarButtonItem = menu_itm;
    }
    
    self.quickRefresh = [[YangRefresh alloc] initWithType:JHRefreshControlTypeSlideDown];
    __weak id weakSelf = self;
    [self.quickRefresh addToScrollView:self.tableView withRefreshBlock:^{
        [weakSelf tableViewWasPulledToRefresh];
    }];

}

-(void) menuButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YPostVCUserUpvotePostNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YUtilUserUpvotePostCallbackFinishedNotification object:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_comment_field resignFirstResponder];
}

#pragma mark TableViewStuff

- (UITableViewCell *)tableView:(UITableView *)otherTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:otherTableView cellForRowAtIndexPath:indexPath object:[self objectAtIndexPath:indexPath]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.objects count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 74.0f;
}

#pragma mark - PostCellDelegate

-(void) didTapUpvoteButton:(UIButton *)button forPostCell:(PostCell *)postCell  forPost:(PFObject *)thePost {

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
    }
}

-(NSString*) normalize: (NSString *) number{
    NSMutableCharacterSet *nonNumberCharacterSet = [NSMutableCharacterSet decimalDigitCharacterSet];
    [nonNumberCharacterSet invert];
    
    return [[number componentsSeparatedByCharactersInSet:nonNumberCharacterSet] componentsJoinedByString:@""];
}

#pragma mark - PFQueryStuff

- (PFQuery *)queryForTable {
    
    PFQuery *upvote = [PFQuery queryWithClassName:kActivityClassKey];
    [upvote whereKey:kActivityPostKey equalTo:post];
    [upvote includeKey:kActivityFromUserKey];
    [upvote whereKey:kActivityTypeKey equalTo:kActivityTypeUpvote];
    [upvote orderByAscending:@"createdAt"];
    
    
    if (self.objects.count == 0) {
        upvote.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    return upvote;
}

-(void)objectsDidLoad:(NSError *)error {
    [self.quickRefresh endRefreshing];
}

-(void)tableViewWasPulledToRefresh {
    [self loadObjects];
}

- (BFTask<NSArray<__kindof PFObject *> *> *)loadObjects {
    return [self loadObjects:0 clear:YES];
}

- (BFTask<NSArray<__kindof PFObject *> *> *)loadObjects:(NSInteger)page clear:(BOOL)clear {
    
    PFQuery *query = [self queryForTable];
    
    BFTaskCompletionSource<NSArray<__kindof PFObject *> *> *source = [BFTaskCompletionSource taskCompletionSource];
    [query findObjectsInBackgroundWithBlock:^(NSArray *foundObjects, NSError *error) {
        if (error) {
            NSLog(@"Error loading objects\n");
            NSLog(@"%@", [error localizedDescription]);
        } else {
            
            if (clear) {
                [_mutableObjects removeAllObjects];
            }
            
            [_mutableObjects addObjectsFromArray:foundObjects];
            [self.tableView reloadData];
            
            if (scrollToLast && self.objects.count != 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    scrollToLast = NO;
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.objects.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                });
            }
        }
        
        [self objectsDidLoad:error];
        
        if (error) {
            [source trySetError:error];
        } else {
            [source trySetResult:foundObjects];
        }
    }];
    
    return source.task;
}

- (void)tableView:(UITableView *)tableView
    configureCell:(FriendCell *)cell
      atIndexPath:(NSIndexPath *)indexPath
           object:(PFObject *)object {
    
    PFUser *usa = object[@"fromUser"];
    
    PFFile * propic = usa[@"propic"];
    if (propic != nil) {
        [cell.usr_pro sd_setImageWithURL:[NSURL URLWithString:propic.url]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapUserPic:)];
        tap.numberOfTapsRequired = 1;
        
        [cell addGestureRecognizer:tap];
        cell.fwend = usa;
        cell.username.text = [NSString stringWithFormat:@"%@ %@", usa[@"first"], usa[@"last"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (FriendCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
                   object:(PFObject *)object {
    
    FriendCell *cell = (FriendCell *) [tableView dequeueReusableCellWithIdentifier:@"PostVCUpCell"];
    if (!cell) {
        cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PostVCUpCell"];
    }
    
    [self tableView:tableView configureCell:cell atIndexPath:indexPath object:object];

    return cell;
}

- (NSArray<__kindof PFObject *> *)objects {
    return _mutableObjects;
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    return self.objects[indexPath.row];
}

-(void)didTapUserPic:(UITapGestureRecognizer *) tappy {
    FriendCell * fcell = (FriendCell *) tappy.view;
    
    UserProfileVC *upvc = [[UserProfileVC alloc] initWithUser:fcell.fwend];
    [self.navigationController pushViewController:upvc animated:YES];
}

@end
