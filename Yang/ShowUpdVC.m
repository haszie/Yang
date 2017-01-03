//
//  ShowUpdViewController.m
//  Yang
//
//  Created by Biggie Smallz on 12/10/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "ShowUpdVC.h"
#import "UserProfileVC.h"

@interface ShowUpdVC ()

@end

@implementation ShowUpdVC

- (id)initWithPFObject: (PFObject *) obj {
    self = [super initWithStyle:UITableViewStylePlain];
    if(self) {
        self.post = obj;
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Up'd"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:@"UpCell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) didTapFriend:(UITapGestureRecognizer *) tap {
    FriendCell *fc = (FriendCell *) tap.view;
    UserProfileVC *upvc = [[UserProfileVC alloc] initWithUser:fc.fwend];
    [self.navigationController pushViewController:upvc animated:YES];
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    
    PFQuery *upvote = [PFQuery queryWithClassName:kActivityClassKey];
    [upvote whereKey:kActivityPostKey equalTo:self.post];
    [upvote includeKey:kActivityFromUserKey];
    [upvote whereKey:kActivityTypeKey equalTo:kActivityTypeUpvote];
    [upvote orderByAscending:@"createdAt"];

    
    if (self.objects.count == 0) {
        upvote.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    return upvote;
}
- (void)tableView:(UITableView *)tableView
    configureCell:(FriendCell *)cell
      atIndexPath:(NSIndexPath *)indexPath
           object:(PFObject *)object {
    
    PFUser *usa = object[@"fromUser"];
    
    PFFile * propic = usa[@"propic"];
    if (propic != nil) {
        [cell.usr_pro sd_setImageWithURL:[NSURL URLWithString:propic.url]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapFriend:)];
        tap.numberOfTapsRequired = 1;
        
        [cell addGestureRecognizer:tap];
        cell.fwend = usa;
        cell.username.text = [NSString stringWithFormat:@"%@ %@", usa[@"first"], usa[@"last"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (FriendCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"UpCell";
    
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self tableView:tableView configureCell:cell atIndexPath:indexPath object:object];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

@end
