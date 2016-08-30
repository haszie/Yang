//
//  SendKarmaVC.h
//  Yang
//
//  Created by Biggie Smallz on 1/15/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Bolts/Bolts.h>
#import <ParseUI/ParseUI.h>

#import <MMDrawerController/MMDrawerController.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import <MMDrawerController/MMDrawerController.h>

#import <SDWebImage/UIImageView+WebCache.h>

#import <MMNumberKeyboard/MMNumberKeyboard.h>

#import "DBCameraViewController.h"
#import "DBCameraContainerViewController.h"
#import "DBCameraSegueViewController.h"
#import "DBCameraView.h"

#import "MBProgressHUD.h"

#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"

#import "FeedVC.h"
#import "FriendCell.h"
#import "CameraNAV.h"

@interface SendKarmaVC : UIViewController <UITextViewDelegate, UITextFieldDelegate, MMNumberKeyboardDelegate,
                                            UITableViewDataSource, UITableViewDelegate, DBCameraViewControllerDelegate>

-(id) initWithUsername:(PFUser *) user;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *recipient;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *amount;
@property (weak, nonatomic) IBOutlet UIImageView *recv_img;
@property (weak, nonatomic) IBOutlet UIImageView *send_img;
@property (weak, nonatomic) IBOutlet UILabel *sentence_lbl;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextView *desc;

@property (strong, nonatomic, nullable) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UIButton *camera_btn;
@property (weak, nonatomic) IBOutlet UIButton *send_btn;

@property (nullable, strong, nonatomic) UITableView * friends;
@property (nullable, strong, nonatomic) NSString * searchTerm;

@property (nullable, weak, nonatomic) NSString *usernameToSend;
@property (nullable, weak, nonatomic) PFUser *sendToUser;

@property (nullable, nonatomic, copy, readonly) NSArray<__kindof PFObject *> *objects;

- (nullable PFObject *)objectAtIndexPath:(nullable NSIndexPath *)indexPath;
- (nullable BFTask<NSArray<__kindof PFObject *> *> *)loadObjects;
- (nullable BFTask<NSArray<__kindof PFObject *> *> *)loadObjects:(NSInteger)page clear:(BOOL)clear;
- (nullable PFQuery *)queryForTable;

@end