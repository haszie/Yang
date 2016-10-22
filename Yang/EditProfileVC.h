//
//  EditProfileVC.h
//  Yang
//
//  Created by Biggie Smallz on 2/23/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "RSKImageCropper.h"
#import "MBProgressHUD.h"
#import "YUtil.h"

@interface EditProfileVC : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate, UINavigationControllerDelegate,
                                                UIImagePickerControllerDelegate, UITextFieldDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource>

@property (weak, nonatomic) UITextField *firstName;
@property (weak, nonatomic) UITextField *lastName;
@property (weak, nonatomic) UITextField *blurb;
//@property (weak, nonatomic) UITextField *email;
@property (weak, nonatomic) UIButton *finish;
@property (weak, nonatomic) UIButton *camera;
@property (strong, nonatomic) UIImage *profileImage;
@property (weak, nonatomic) UIScrollView *scroller;

@end
