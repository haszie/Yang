//
//  FwendsVC.h
//  Yang
//
//  Created by Biggie Smallz on 6/7/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Bolts/Bolts.h>
#import <MMDrawerController/MMDrawerController.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

#import "MBProgressHUD.h"

#import "APAddressBook.h"
#import "APContact.h"
#import "PhoneFriendsCell.h"
#import "ProfileInfo.h"
#import "YUtil.h"
#import "UserProfileVC.h"

@interface FwendsVC : UITableViewController <PhoneFriendsDelegate, ProPicDelegate, MFMessageComposeViewControllerDelegate>

@property (nullable, nonatomic, strong) APAddressBook *book;
@property (nullable, nonatomic, copy, readonly) NSArray<__kindof APContact *> *contacts;
@property (nullable, nonatomic, weak) NSString *phoneNumberReferred;
@property (strong, nonatomic, nullable) MBProgressHUD *hud;

- (nullable BFTask<NSArray<__kindof APContact *> *> *)loadContacts;

@end
