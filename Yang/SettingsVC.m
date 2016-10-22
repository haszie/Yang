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
    
    UIButton *editProfile = [[UIButton alloc] initWithFrame:CGRectMake(32.0f, 64.0f, self.view.frame.size.width - 64.0f, 60.0f)];
    [editProfile setTitle:@"Edit Profile" forState:UIControlStateNormal];
    [editProfile addTarget:self action:@selector(editProfile) forControlEvents:UIControlEventTouchUpInside];
    [editProfile setBackgroundImage:[YUtil imageWithColor:[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0f]] forState:UIControlStateNormal];
    [editProfile setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    editProfile.layer.masksToBounds = YES;
    editProfile.layer.cornerRadius = 3.0f;
    
    UIButton *permissions = [[UIButton alloc] initWithFrame:CGRectMake(32.0f, 64.0f + 60.0f + 32.0f, self.view.frame.size.width - 64.0f, 60.0f)];
    [permissions setTitle:@"Permissions" forState:UIControlStateNormal];
    [permissions addTarget:self action:@selector(doPermissions) forControlEvents:UIControlEventTouchUpInside];
    [permissions setBackgroundImage:[YUtil imageWithColor:[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0f]] forState:UIControlStateNormal];
    [permissions setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    permissions.layer.masksToBounds = YES;
    permissions.layer.cornerRadius = 3.0f;
    
    UIButton *logOut = [[UIButton alloc] initWithFrame:CGRectMake(32.0f, 64.0f + 60.0f + 32.0f + 32.0f + 60.0f, self.view.frame.size.width - 64.0f, 60.0f)];
    [logOut setTitle:@"Log out" forState:UIControlStateNormal];
    [logOut setBackgroundColor:[UIColor blackColor]];
    [logOut setTitleColor:[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [logOut addTarget:self action:@selector(didHitLogOut) forControlEvents:UIControlEventTouchUpInside];
    logOut.layer.cornerRadius = 3.0f;

    UIImage *menu_img = [UIImage imageNamed:@"menu-alt"];
    CGRect menu_frame = CGRectMake(0, 0, 22, 22);
    
    UIButton *menu_btn = [[UIButton alloc] initWithFrame:menu_frame];
    [menu_btn addTarget:self action:@selector(menuButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [menu_btn setImage:menu_img forState:UIControlStateNormal];
    
    UIBarButtonItem *menu_itm= [[UIBarButtonItem alloc] initWithCustomView:menu_btn];
    
    self.navigationItem.leftBarButtonItem = menu_itm;
    self.title = @"Settings";
 
    [self.view addSubview:editProfile];
    [self.view addSubview:permissions];
    [self.view addSubview:logOut];
}

-(void) editProfile {
    EditProfileVC *evc = [[EditProfileVC alloc] init];
    [self.navigationController pushViewController:evc animated:YES];
}

-(void) menuButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void) doPermissions {
    VWWCameraPermission *camera = [VWWCameraPermission permissionWithLabelText:@"Yang Permissions"];
    
    VWWMicrophonePermission *microphone = [VWWMicrophonePermission permissionWithLabelText:@"The videos need to have sound!"];
    
    VWWPhotosPermission *photos = [VWWPhotosPermission permissionWithLabelText:@"If you would like to upload a profile picture from your camera roll, Yang needs permission."];
    
    VWWContactsPermission *contacts = [VWWContactsPermission permissionWithLabelText:@"Yang needs to have access to your contacts to find friends."];
    
    VWWNotificationsPermission *notifications = [VWWNotificationsPermission permissionWithLabelText:@"Yang will notify you when someone sends you karma."];
    
    NSArray *permissions = @[camera, microphone, photos, contacts, notifications, ];
    
    [VWWPermissionsManager optionPermissions:permissions
                                       title:@"We need a couple things from you before we get started. You can change these settings at any time."
                          fromViewController:self
                                resultsBlock:^(NSArray *permissions) {
                                    [permissions enumerateObjectsUsingBlock:^(VWWPermission *permission, NSUInteger idx, BOOL *stop) {
                                        NSLog(@"%@ - %@", permission.type, [permission stringForStatus]);
                                    }];
    }];
}

-(void) didHitLogOut {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        //LoginVC *lgvc = [[LoginVC alloc] init];
        [[[UIApplication sharedApplication] windows] firstObject].rootViewController = [[LoginVC alloc] init];
    }];
}


@end
