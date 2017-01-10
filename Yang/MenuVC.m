//
//  MenuVC.m
//  Yang
//
//  Created by Biggie Smallz on 1/15/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "MenuVC.h"

@interface MenuVC ()

@end

@implementation MenuVC

static HomeFeedVC *home_vcr;
static FwendsVC *why_cant_we_be_vc;
static SettingsVC *set_things;
static LoginVC *leggo;
static ActivityFeedVC *nike;

+(HomeFeedVC *) home {
    if (!home_vcr) {
        home_vcr = [[HomeFeedVC alloc] initWithStyle:UITableViewStylePlain];
    }
    return home_vcr;
}

+(FwendsVC *) fwends {
    if (!why_cant_we_be_vc) {
        why_cant_we_be_vc = [[FwendsVC alloc] initWithStyle:UITableViewStylePlain];
    }
    return why_cant_we_be_vc;
}

+(SettingsVC *) settings_mon {
    if (!set_things) {
        set_things = [[SettingsVC alloc] init];
    }
    return set_things;
}

+(LoginVC *) logon {
    if (!leggo) {
        leggo = [[LoginVC alloc] init];
    }
    return leggo;
}

+(ActivityFeedVC *) activities {
    if (!nike) {
        nike = [[ActivityFeedVC alloc] initWithStyle:UITableViewStylePlain];
    }
    return nike;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0f];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *heada= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250.0f, 200.0f)];
    [heada setBackgroundColor:[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0f]];
    
    self.propic = [[ProPicIV alloc] initWithFrame:CGRectMake(16.0f, 64.0f, 70.0f, 70.0f) withUser:[PFUser currentUser]];
    
    UIButton *go = [[UIButton alloc] initWithFrame:CGRectMake(16.0f, 64.0f, 200, 70.0f)];
    [go setBackgroundColor:[UIColor clearColor]];
    [go addTarget:self action:@selector(didHitUserYo) forControlEvents:UIControlEventTouchUpInside];
    
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(16.0f + 70.0f + 8.0f, 64.0f, 250.0f - 16.0f - 70.0f, 24.0f)];
    [self.name setTextColor:[UIColor blackColor]];
    [self.name setFont:[UIFont fontWithName:@"OpenSans-Light" size:18.0f]];
    self.name.text = [NSString stringWithFormat:@"%@ %@", [PFUser currentUser][@"first"], [PFUser currentUser][@"last"]];
    
    self.blurb = [[UILabel alloc] initWithFrame:CGRectMake(16.0f + 70.0f + 8.0f, 64.0f + 24.0f, 250.0f - 16.0f - 70.0f - 16.0f, 46.0f)];
    [self.blurb setTextColor:[UIColor blackColor]];
    [self.blurb setFont:[UIFont fontWithName:@"OpenSans-Light" size:12.0f]];
    self.blurb.text = [PFUser currentUser][@"blurb"];
    self.blurb.numberOfLines = 5;
    [self.blurb sizeToFit];
    
    self.karma = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, 64.0f + 70.0f + 8.0f, 200.0f, 14.0f)];
    [self.karma setTextColor:[UIColor blackColor]];
    [self.karma setFont:[UIFont fontWithName:@"OpenSans-Light" size:12.0f]];
    self.karma.text = [NSString stringWithFormat:@"%@ karma", [NSNumberFormatter localizedStringFromNumber:[PFUser currentUser][@"karma"]
                                                                                           numberStyle:NSNumberFormatterDecimalStyle]];
    [self.karma setTextAlignment:NSTextAlignmentLeft];
    
    [heada addSubview:self.propic];
    [heada addSubview:self.name];
    [heada addSubview:self.blurb];
    [heada addSubview:go];
    [heada addSubview:self.karma];
    
    self.tableView.tableHeaderView = heada;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateProfile:)
                                                 name:@"UpdateProfile"
                                               object:nil];
}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

-(void) updateProfile: (NSNotification *) note {
    [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            self.karma.text = [NSString stringWithFormat:@"%@ karma", [NSNumberFormatter localizedStringFromNumber:object[@"karma"] numberStyle:NSNumberFormatterDecimalStyle]];
            self.name.text = [NSString stringWithFormat:@"%@ %@", object[@"first"], object[@"last"]];
            self.blurb.text = object[@"blurb"];
            self.propic.theUser = (PFUser*)object;

        } else {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

-(void) didHitUserYo {
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        UINavigationController *nav = (UINavigationController *) [self.mm_drawerController centerViewController];
        UserProfileVC *userPro = [[UserProfileVC alloc] initWithUser:[PFUser currentUser]];
        userPro.addMenuButton = YES;
        
        [nav setViewControllers:@[userPro] animated:YES];
    }];
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 ) {
        [self gotoVC:[MenuVC home]];
    } else if (indexPath.row == 1) {
        [self gotoVC:[MenuVC fwends]];
    } else if (indexPath.row == 2) {
        [self gotoVC:[MenuVC activities]];
    } else if (indexPath.row == 3) {
        [self gotoVC:[MenuVC settings_mon]];
    } else if (indexPath.row == 4) {

    }
}

-(void) gotoVC:(UIViewController *) vc {
    UINavigationController *nav = (UINavigationController *) [self.mm_drawerController centerViewController];
    [nav setViewControllers:@[vc] animated:NO];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = (MenuCell *) [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    cell.icon.contentMode = UIViewContentModeScaleAspectFit;
    cell.icon.clipsToBounds = YES;

     if (indexPath.row == 0) {
        cell.label.text = @"Home";
        cell.icon.image = [UIImage imageNamed:@"home-md"];
    } else if (indexPath.row == 1) {
        cell.label.text = @"Friends";
        cell.icon.image = [UIImage imageNamed:@"friends_menu_icon"];
    } else if (indexPath.row == 2) {
        cell.label.text = @"Activity";
        cell.icon.image = [UIImage imageNamed:@"activity_menu_icon"];
    } else if (indexPath.row == 3) {
        cell.label.text = @"Settings";
        cell.icon.image = [UIImage imageNamed:@"settings_menu_icon"];
    } else if (indexPath.row == 4) {
        cell.label.text = @"About";
        cell.icon.image = [UIImage imageNamed:@"about_menu_icon"];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}



@end
