//
//  ActivityFeedVC.m
//  Yang
//
//  Created by Biggie Smallz on 6/7/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "ActivityFeedVC.h"

@interface ActivityFeedVC ()

@end

@implementation ActivityFeedVC

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.parseClassName = kActivityClassKey;
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 30;
    }
    return self;
}

-(void) menuButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView * frame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIImage *logo = [UIImage imageNamed:@"activity"];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:logo];
    logoView.frame = CGRectMake(75, 0, 150, 44);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    
    [frame addSubview:logoView];
    self.navigationItem.titleView = logoView;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    button.userInteractionEnabled = NO;
    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;

    UIImage *menu_img = [UIImage imageNamed:@"menu-alt"];
    CGRect menu_frame = CGRectMake(0, 0, 22, 22);
    
    UIButton *menu_btn = [[UIButton alloc] initWithFrame:menu_frame];
    [menu_btn addTarget:self action:@selector(menuButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [menu_btn setImage:menu_img forState:UIControlStateNormal];
    
    UIBarButtonItem *menu_itm= [[UIBarButtonItem alloc] initWithCustomView:menu_btn];
    
    self.navigationItem.leftBarButtonItem = menu_itm;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:@"ActivityCell"];
}

-(void)viewDidAppear:(BOOL)animated {
    [self loadObjects];
}

- (PFQuery *)queryForTable {
    PFQuery *theQuery = [PFQuery queryWithClassName:kActivityClassKey];
    [theQuery whereKey:kActivityToUserKey equalTo:[PFUser currentUser]];
    [theQuery includeKey:kActivityFromUserKey];
    [theQuery includeKey:kActivityPostKey];
    [theQuery orderByDescending:@"createdAt"];
    [theQuery setCachePolicy:kPFCachePolicyNetworkElseCache];
    
    return theQuery;
}

- (PFTableViewCell *)tableView:(UITableView *)otherTableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    
    PFTableViewCell *cell = [super tableView:otherTableView cellForNextPageAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setFont:[UIFont fontWithName:@"OpenSans" size:16.0f]];
    cell.textLabel.text = @"More activity...";
    
    return cell;
}

- (FriendCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"ActivityCell";
    
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    PFUser *fromUser = object[kActivityFromUserKey];
    
    if ([object[kActivityTypeKey] isEqualToString:kActivityTypeFollow]) {
        [cell.username setText:[NSString stringWithFormat:@"%@ %@ is now following you", fromUser[@"first"], fromUser[@"last"]]];
    } else if ([object[kActivityTypeKey] isEqualToString:kActivityTypeUpvote]) {
        [cell.username setText:[NSString stringWithFormat:@"%@ gave you an upvote", fromUser[@"first"]]];
    } else if ([object[kActivityTypeKey] isEqualToString:kActivityTypeKarma]) {
        PFObject * post = object[@"post"];
        [cell.username setText:[NSString stringWithFormat:@"%@ sent you %d karma", fromUser[@"first"], [post[@"amt"] intValue]]];
    }
    
    PFUser *usa = object[kActivityFromUserKey];
    PFFile * propic = usa[@"propic"];
    [cell.usr_pro sd_setImageWithURL:[NSURL URLWithString:propic.url]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self objectAtIndexPath:indexPath];
    
    if ([object[kActivityTypeKey] isEqualToString:kActivityTypeFollow]) {
        UserProfileVC *vc = [[UserProfileVC alloc] initWithUser:object[kActivityFromUserKey]];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([object[kActivityTypeKey] isEqualToString:kActivityTypeUpvote] || [object[kActivityTypeKey] isEqualToString:kActivityTypeKarma] ) {
        PostVC *vc = [[PostVC alloc] initWithPFObject:object[kActivityPostKey] withHeight:[YUtil calcHeight:object[kActivityPostKey] withFrame:self.view.frame]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

@end
