//
//  LoginVC.h
//  Yang
//
//  Created by Biggie Smallz on 2/15/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MainVC.h"
#import "RSKImageCropper.h"
#import "VWWPermissionKit.h"

@interface LoginVC : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,
                                        UITextFieldDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource>

@property (weak, nonatomic) UITextField *phoneNumber;
@property (weak, nonatomic) UITextField *textCode;
@property (weak, nonatomic) UITextField *firstName;
@property (weak, nonatomic) UITextField *lastName;
@property (weak, nonatomic) UITextField *blurb;
@property (weak, nonatomic) UITextField *email;

@property (weak, nonatomic) UIButton *finish;
@property (weak, nonatomic) UIButton *continueButton;
@property (weak, nonatomic) UIButton *keepGoing;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIScrollView *formScroller;
@property (weak, nonatomic) UIScrollView *permissionsScroller;

@property (weak, nonatomic) PFUser *theNewUser;

@end
