//
//  SettingsVC.m
//  Yang
//
//  Created by Biggie Smallz on 2/23/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "SettingsVC.h"
#import "MenuVC.h"

@interface SettingsVC ()

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView * frame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIImage *logo = [UIImage imageNamed:@"settings"];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:logo];
    logoView.frame = CGRectMake(0, 0, 150, 44);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    [frame addSubview:logoView];
    self.navigationItem.titleView = logoView;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    button.userInteractionEnabled = NO;
    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *logOut = [[UIButton alloc] initWithFrame:CGRectMake(32.0f, 64.0f, self.view.frame.size.width - 64.0f, 60.0f)];
    [logOut setTitle:@"Log out" forState:UIControlStateNormal];
    [logOut setBackgroundColor:[UIColor blackColor]];
    [logOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logOut addTarget:self action:@selector(didHitLogOut) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *menu_img = [UIImage imageNamed:@"menu-alt"];
    CGRect menu_frame = CGRectMake(0, 0, 22, 22);
    
    UIButton *menu_btn = [[UIButton alloc] initWithFrame:menu_frame];
    [menu_btn addTarget:self action:@selector(menuButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [menu_btn setImage:menu_img forState:UIControlStateNormal];
    
    UIBarButtonItem *menu_itm= [[UIBarButtonItem alloc] initWithCustomView:menu_btn];
    
    self.navigationItem.leftBarButtonItem = menu_itm;
    self.title = @"Settings";
    
    [self.view addSubview:logOut];
}

-(void) menuButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void) didHitLogOut {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        //LoginVC *lgvc = [[LoginVC alloc] init];
        [[[UIApplication sharedApplication] windows] firstObject].rootViewController = [MenuVC logon];
    }];
}


@end
