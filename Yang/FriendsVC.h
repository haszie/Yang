//
//  FriendsVC.h
//  Yang
//
//  Created by Biggie Smallz on 2/17/16.
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

#import "APAddressBook.h"
#import "APContact.h"
#import "PhoneFriendsCell.h"
#import "ProfileInfo.h"
#import "YUtil.h"
#import "UserProfileVC.h"

@interface FriendsVC : UITableViewController <UISearchResultsUpdating, PhoneFriendsDelegate, ProPicDelegate, MFMessageComposeViewControllerDelegate>

@property (nullable, nonatomic, strong) APAddressBook *book;
@property (nullable, nonatomic) NSArray<__kindof APContact *> *contacts;
@property (nullable, nonatomic, strong) UISearchController *searchController;
@property (nullable, nonatomic, weak) NSString *phoneNumberReferred;

- (nullable APContact *)contactAtIndexPath:(nullable NSIndexPath *)indexPath;
- (nullable BFTask<NSArray<__kindof APContact *> *> *)loadContacts;

@end
