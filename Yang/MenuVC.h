//
//  MenuVC.h
//  Yang
//
//  Created by Biggie Smallz on 1/15/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MMDrawerController/MMDrawerController.h>
#import "MenuCell.h"
#import "ProPicIV.h"
#import "YUtil.h"
#import "UserProfileVC.h"
#import "LoginVC.h"
#import "ActivityFeedVC.h"
#import "HomeFeedVC.h"
#import "FwendsVC.h"
#import "SettingsVC.h"

@interface MenuVC : UITableViewController

@property (nonatomic) ProPicIV * propic;
@property (nonatomic) UILabel * karma;
@property (nonatomic) UILabel * name;
@property (nonatomic) UILabel * blurb;

+(SettingsVC *) settings_mon;
+(HomeFeedVC *) home;
+(FwendsVC *) fwends;
+(LoginVC *) logon;
+(ActivityFeedVC *) activities;

@end
