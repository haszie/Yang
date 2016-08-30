//
//  UserProfileVC.m
//  Yang
//
//  Created by Biggie Smallz on 2/12/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "UserProfileVC.h"

@implementation UserProfileVC
@synthesize theUser;

- (id)initWithUser:(PFUser *) aUser {
    self = [super init];
    if (self) {
        theUser = aUser;
        self.quickEnabled = NO;
        self.loadingViewEnabled = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    PFFile *propic = self.theUser[kUserProfilePicture];
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    
    UIImageView *proImg = [[UIImageView alloc] initWithFrame:
                       CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    
    proImg.contentMode = UIViewContentModeScaleAspectFill;
    proImg.clipsToBounds = YES;
    
    [proImg sd_setImageWithURL:[NSURL URLWithString:propic.url] placeholderImage:[UIImage imageNamed:@"usr"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [bg addSubview:proImg];
        UIImage* flippedImage = [UIImage imageWithCGImage:image.CGImage
                                                    scale:image.scale
                                              orientation:UIImageOrientationDownMirrored];
        UIImageView *flippedImageView = [[UIImageView alloc] initWithFrame:
                                         CGRectMake(0, self.view.frame.size.width, self.view.frame.size.width, self.view.frame.size.width)];
        
        flippedImageView.contentMode = UIViewContentModeScaleAspectFill;
        flippedImageView.clipsToBounds = YES;
        [flippedImageView setImage:flippedImage];
        [bg addSubview:flippedImageView];
        
        self.tableView.backgroundView = bg;
    }];    
    
    ProfileHeader *ph = [[ProfileHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width + 193.75) withUser:self.theUser];
    [ph.sendKarma addTarget:self action:@selector(didHitSendKarma) forControlEvents:UIControlEventTouchUpInside];
    [ph.editProfile addTarget:self action:@selector(didHitEditProfile) forControlEvents:UIControlEventTouchUpInside];
    
    if (ph.editProfile != nil) {
        [ph.editProfile addTarget:self action:@selector(didHitEditProfile) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.title = self.theUser[@"first"];
    
    if (self.addMenuButton) {
        UIImage *menu_img = [UIImage imageNamed:@"menu-alt"];
        CGRect menu_frame = CGRectMake(0, 0, 22, 22);
        
        UIButton *menu_btn = [[UIButton alloc] initWithFrame:menu_frame];
        [menu_btn addTarget:self action:@selector(menuButtonPress) forControlEvents:UIControlEventTouchUpInside];
        [menu_btn setImage:menu_img forState:UIControlStateNormal];
        
        UIBarButtonItem *menu_itm= [[UIBarButtonItem alloc] initWithCustomView:menu_btn];
        
        self.navigationItem.leftBarButtonItem = menu_itm;
    }
    
    self.tableView.tableHeaderView = ph;
    self.view.backgroundColor = [UIColor whiteColor];
    
//    PFQuery *giveKarmaStatsQuery = [PFQuery queryWithClassName:@"post"];
//    [giveKarmaStatsQuery whereKey:@"giver" equalTo:self.theUser];
//    
//    PFQuery *takeKarmaStatsQuery = [PFQuery queryWithClassName:@"post"];
//    [takeKarmaStatsQuery whereKey:@"taker" equalTo:self.theUser];
//    
//
//    PFQuery *commentQuery = [PFQuery queryWithClassName:@"activity"];
//    [commentQuery whereKey:@"type" equalTo:@"comment"];
//    [commentQuery whereKey:@"fromUser" equalTo:self.theUser];
//    
//    NSInteger gaveUpvote = [giveUpvoteQuery countObjects];
//    NSInteger chatted = [commentQuery countObjects];
//    
//    NSArray *gave = [giveKarmaStatsQuery findObjects];
//    NSArray *took = [takeKarmaStatsQuery findObjects];
//    
//    int gave_sum = 0, took_sum = 0;
//    
//    int i;
//    for (i = 0; i < gave.count; i++) {
//        gave_sum += [gave[i][@"amt"] intValue];
//    }
//    
//    for (i = 0; i < took.count; i++) {
//        took_sum += [took[i][@"amt"] intValue];
//    }
// 
//    NSString *info = [NSString stringWithFormat:@"User: %@\ngave : %ld\nnum comments: %ld\ngave karma: %d\ntook karma: %d\n", self.theUser[@"first"], (long)gaveUpvote, (long) chatted, gave_sum, took_sum];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stats"
//                                                    message:info
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];

}

-(void) menuButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(PFQuery *)queryForTable {
    PFQuery *senders = [PFQuery queryWithClassName:kPostClassKey];
    [senders whereKey:kPostSenderKey equalTo:theUser];
    
    PFQuery *recvrs = [PFQuery queryWithClassName:kPostClassKey];
    [recvrs whereKey:kPostReceiverKey equalTo:theUser];
    
    NSMutableArray *theQs = [NSMutableArray array];
    [theQs addObject:senders];
    [theQs addObject:recvrs];
    
    PFQuery *comb = [PFQuery orQueryWithSubqueries:[theQs copy]];
    [comb includeKey:kPostSenderKey];
    [comb includeKey:kPostReceiverKey];
    [comb setCachePolicy:kPFCachePolicyNetworkOnly];
    [comb orderByDescending:@"createdAt"];
    
    if (self.objects.count == 0) { 
        [comb setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    return comb;
}

-(void) didHitSendKarma {
    SendKarmaVC *vc = [[SendKarmaVC alloc] initWithUsername:self.theUser];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void) didHitEditProfile {
    EditProfileVC *evc = [[EditProfileVC alloc] init];
    [self.navigationController pushViewController:evc animated:YES];
}

@end