//
//  LoginVC.m
//  Yang
//
//  Created by Biggie Smallz on 2/15/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "LoginVC.h"
#import "MenuVC.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.translucent = NO;

    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 120.0f, self.view.frame.size.width, self.view.frame.size.height - 120.0f)];
    [scroller setContentSize:CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height)];
    [scroller setScrollEnabled:NO];
    scroller.delegate = self;
    self.scrollView = scroller;
    
    UIImageView *yangTitle = [[UIImageView alloc] initWithFrame:CGRectMake(32.0f, 32.0f, self.view.frame.size.width - 64.0f, 88.0)];
    [yangTitle setImage:[UIImage imageNamed:@"logo-2"]];
    yangTitle.contentMode = UIViewContentModeScaleAspectFit;

    UIView *logoBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120.0f)];
    [logoBG setBackgroundColor:[YUtil theColor]];
    
    UILabel *welcome = [[UILabel alloc] initWithFrame:
                             CGRectMake(32.0f, 16.0f, self.view.frame.size.width - 64.0f, 88.0f)];
    [welcome setFont:[UIFont fontWithName:@"OpenSans" size:18.0f]];
    [welcome setTextColor:[UIColor blackColor]];
    welcome.numberOfLines = 0;
    welcome.text = @"Welcome! Enter your phone number to get started.";
    [welcome setTextAlignment:NSTextAlignmentJustified];
    [welcome sizeToFit];
    
    UITextField * phoneNumber = [[UITextField alloc] initWithFrame:
                                 CGRectMake(0, welcome.frame.origin.y + welcome.frame.size.height + 16.0f, self.view.frame.size.width, 60.0f)];
    [phoneNumber setBackgroundColor:[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0f]];
    [phoneNumber setFont:[UIFont fontWithName:@"OpenSans" size:24.0f]];
    [phoneNumber setPlaceholder:@"(555) - 162 - 8345"];
    [phoneNumber setTextColor:[UIColor blackColor]];
    [phoneNumber setKeyboardType:UIKeyboardTypeNumberPad];
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32.0f, 60.0f)];
    [phoneNumber setLeftViewMode:UITextFieldViewModeAlways];
    [phoneNumber setLeftView:spacerView];
    phoneNumber.delegate = self;
    phoneNumber.tag = 5;
    self.phoneNumber = phoneNumber;
    
    UIButton *continueButton = [[UIButton alloc] initWithFrame:
                                CGRectMake(32.0f, phoneNumber.frame.origin.y + phoneNumber.frame.size.height + 24.0f, self.view.frame.size.width - 64.0f, 50.0f)];
    [continueButton addTarget:self action:@selector(didHitContinue) forControlEvents:UIControlEventTouchUpInside];
    [continueButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:24.0f]];
    [continueButton setBackgroundImage:[YUtil imageWithColor:[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0f]] forState:UIControlStateNormal];
    [continueButton setBackgroundImage:[YUtil imageWithColor:[UIColor colorWithRed:32.0/255.0f green:164.0/255.0f blue:0.0/255.0f alpha:1.0f]] forState:UIControlStateSelected];
    [continueButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    [continueButton setTitle:@"Continue" forState:UIControlStateSelected];
    [continueButton setUserInteractionEnabled:NO];
    [continueButton setSelected:NO];
    [continueButton setAdjustsImageWhenHighlighted:NO];
    continueButton.layer.masksToBounds = YES;
    continueButton.layer.cornerRadius = 3.0f;
    self.continueButton = continueButton;

    UILabel *instructions = [[UILabel alloc] initWithFrame:
                             CGRectMake(32.0f + self.view.frame.size.width, 16.0f, self.view.frame.size.width - 64.0f, 88.0f)];
    [instructions setFont:[UIFont fontWithName:@"OpenSans" size:18.0f]];
    [instructions setTextColor:[UIColor blackColor]];
    instructions.numberOfLines = 0;
    instructions.text = @"Enter the code below.";
    [instructions setTextAlignment:NSTextAlignmentJustified];
    [instructions sizeToFit];
    
    UITextField *textCode= [[UITextField alloc] initWithFrame:
                            CGRectMake(self.view.frame.size.width, instructions.frame.origin.y + instructions.frame.size.height + 16.0f, self.view.frame.size.width, 60.0f)];
    [textCode setBackgroundColor:[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0f]];
    [textCode setFont:[UIFont fontWithName:@"OpenSans" size:24.0f]];
    [textCode setPlaceholder:@"1234"];
    [textCode setTextColor:[UIColor blackColor]];
    [textCode setKeyboardType:UIKeyboardTypeNumberPad];
    UIView *spacer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32.0f, 60.0f)];
    [textCode setLeftViewMode:UITextFieldViewModeAlways];
    [textCode setLeftView:spacer];
    textCode.tag = 6;
    textCode.delegate = self;
    self.textCode = textCode;
    
    CGFloat width = (self.view.frame.size.width - 80.0f) / 2.0f;
    
    UIButton *keepGoing = [[UIButton alloc] initWithFrame:
                           CGRectMake(32.0f + self.view.frame.size.width + 16.0f + width, textCode.frame.origin.y + textCode.frame.size.height + 24.0f, width, 50.0f)];
    [keepGoing addTarget:self action:@selector(didHitKeepGoing) forControlEvents:UIControlEventTouchUpInside];
    [keepGoing.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:24.0f]];
    [keepGoing setBackgroundImage:[YUtil imageWithColor:[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0f]] forState:UIControlStateNormal];
    [keepGoing setBackgroundImage:[YUtil imageWithColor:[UIColor colorWithRed:32.0/255.0f green:164.0/255.0f blue:0.0/255.0f alpha:1.0f]] forState:UIControlStateSelected];
    [keepGoing setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [keepGoing setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [keepGoing setTitle:@"Continue" forState:UIControlStateNormal];
    [keepGoing setTitle:@"Continue" forState:UIControlStateSelected];
    [keepGoing setUserInteractionEnabled:NO];
    [keepGoing setSelected:NO];
    [keepGoing setAdjustsImageWhenHighlighted:NO];
    keepGoing.layer.masksToBounds = YES;
    keepGoing.layer.cornerRadius = 3.0f;
    self.keepGoing = keepGoing;
    
    UIButton *resend = [[UIButton alloc] initWithFrame:
                        CGRectMake(32.0f + self.view.frame.size.width, keepGoing.frame.origin.y, width , 50.0f)];
    [resend addTarget:self action:@selector(didHitResend) forControlEvents:UIControlEventTouchUpInside];
    [resend.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:24.0f]];
    [resend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resend setBackgroundColor:[UIColor colorWithRed:170.0/255.0f green:51.0/255.0f blue:17.0/255.0f alpha:1.0f]];
    [resend setTitle:@"Resend" forState:UIControlStateNormal];
    [resend setAdjustsImageWhenHighlighted:NO];
    resend.layer.masksToBounds = YES;
    resend.layer.cornerRadius = 3.0f;

    UILabel *signUpHelp = [[UILabel alloc] initWithFrame:
                             CGRectMake(32.0f, 16.0f, self.view.frame.size.width - 64.0f, 88.0f)];
    [signUpHelp setFont:[UIFont fontWithName:@"OpenSans" size:18.0f]];
    [signUpHelp setTextColor:[UIColor blackColor]];
    signUpHelp.numberOfLines = 0;
    signUpHelp.text = @"Success! Signup almost done.";
    [signUpHelp setTextAlignment:NSTextAlignmentJustified];
    [signUpHelp sizeToFit];
    
    UITextField *firstName = [[UITextField alloc] initWithFrame:
                              CGRectMake(0, signUpHelp.frame.origin.y + signUpHelp.frame.size.height + 16.0f, self.view.frame.size.width, 60.0f)];
    [firstName setBackgroundColor:[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0f]];
    [firstName setFont:[UIFont fontWithName:@"OpenSans" size:24.0f]];
    [firstName setPlaceholder:@"First"];
    [firstName setTextColor:[UIColor blackColor]];
    [firstName setReturnKeyType:UIReturnKeyNext];
    UIView *spacer_again = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32.0f, 60.0f)];
    [firstName setLeftViewMode:UITextFieldViewModeAlways];
    [firstName setLeftView:spacer_again];
    firstName.delegate = self;
    self.firstName = firstName;
    
    UITextField *lastName = [[UITextField alloc] initWithFrame:
                             CGRectMake(0, firstName.frame.origin.y + firstName.frame.size.height + 16.0f, self.view.frame.size.width, 60.0f)];
    [lastName setBackgroundColor:[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0f]];
    [lastName setFont:[UIFont fontWithName:@"OpenSans" size:24.0f]];
    [lastName setPlaceholder:@"Last"];
    [lastName setTextColor:[UIColor blackColor]];
    [lastName setReturnKeyType:UIReturnKeyNext];
    UIView *spacer_again_lol = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32.0f, 60.0f)];
    [lastName setLeftViewMode:UITextFieldViewModeAlways];
    [lastName setLeftView:spacer_again_lol];
    lastName.delegate = self;
    self.lastName = lastName;
    
    UITextField *blurb = [[UITextField alloc] initWithFrame:
                          CGRectMake(0, lastName.frame.origin.y + lastName.frame.size.height + 16.0f, self.view.frame.size.width, 60.0f)];
    [blurb setBackgroundColor:[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0f]];
    [blurb setFont:[UIFont fontWithName:@"OpenSans" size:24.0f]];
    [blurb setPlaceholder:@"Blurb about yourself"];
    [blurb setTextColor:[UIColor blackColor]];
    [blurb setReturnKeyType:UIReturnKeyNext];
    
    UIView *spacer_lol = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32.0f, 60.0f)];
    [blurb setLeftViewMode:UITextFieldViewModeAlways];
    [blurb setLeftView:spacer_lol];
    blurb.delegate = self;
    self.blurb = blurb;
    
//    UITextField *email = [[UITextField alloc] initWithFrame:
//                          CGRectMake(0, blurb.frame.origin.y + blurb.frame.size.height + 16.0f, self.view.frame.size.width, 60.0f)];
//    [email setBackgroundColor:[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0f]];
//    [email setFont:[UIFont fontWithName:@"OpenSans" size:24.0f]];
//    [email setPlaceholder:@"Email (optional)"];
//    [email setTextColor:[UIColor blackColor]];
//    [email setReturnKeyType:UIReturnKeyDone];
//    UIView *spacer_last = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32.0f, 60.0f)];
//    [email setLeftViewMode:UITextFieldViewModeAlways];
//    [email setLeftView:spacer_last];
//    email.delegate = self;
//    self.email = email;
    
//    UIButton *finish = [[UIButton alloc] initWithFrame:
//                                CGRectMake(32.0f, email.frame.origin.y + email.frame.size.height + 24.0f, self.view.frame.size.width - 64.0f, 50.0f)];

    UIButton *finish = [[UIButton alloc] initWithFrame:CGRectMake(0, blurb.frame.origin.y + blurb.frame.size.height + 16.0f,
                                                                  self.view.frame.size.width, 60.0f)];
    
    [finish addTarget:self action:@selector(didHitFinish) forControlEvents:UIControlEventTouchUpInside];
    [finish.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:24.0f]];
    [finish setBackgroundColor:[UIColor colorWithRed:32.0/255.0f green:164.0/255.0f blue:0.0/255.0f alpha:1.0f]];
    [finish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finish setTitle:@"Continue" forState:UIControlStateNormal];
    [finish setAdjustsImageWhenHighlighted:NO];
    self.finish = finish;
    
    UIScrollView * formScroller = [[UIScrollView alloc] initWithFrame:
                                   CGRectMake(self.scrollView.frame.size.width * 2.0f + 1.0f, 1.0f, self.scrollView.frame.size.width - 2.0f, self.scrollView.frame.size.height)];
    
    [formScroller setContentSize:CGSizeMake(formScroller.frame.size.width, formScroller.frame.size.height + 132.0f)];
    [formScroller setScrollEnabled:YES];
    [formScroller setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    formScroller.bounces = YES;
    formScroller.delegate = self;
    self.formScroller = formScroller;
    
    UIScrollView * permissionsScroller = [[UIScrollView alloc] initWithFrame:
                                   CGRectMake(self.scrollView.frame.size.width * 3.0f + 1.0f, 1.0f, self.scrollView.frame.size.width - 2.0f, self.scrollView.frame.size.height)];

    [permissionsScroller setContentSize:CGSizeMake(formScroller.frame.size.width, formScroller.frame.size.height + 132.0f)];
    [permissionsScroller setScrollEnabled:YES];
    [permissionsScroller setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    permissionsScroller.bounces = YES;
    permissionsScroller.delegate = self;
    self.permissionsScroller = formScroller;

    [scroller addSubview:welcome];
    [scroller addSubview:phoneNumber];
    [scroller addSubview:continueButton];
    
    [scroller addSubview:instructions];
    [scroller addSubview:textCode];
    [scroller addSubview:resend];
    [scroller addSubview:keepGoing];
    
    [formScroller addSubview:signUpHelp];
    [formScroller addSubview:firstName];
    [formScroller addSubview:lastName];
    [formScroller addSubview:blurb];
    //[formScroller addSubview:email];
    [formScroller addSubview:finish];
    
    [scroller addSubview:formScroller];
    [scroller addSubview:permissionsScroller];

    [self.view addSubview:logoBG];
    [self.view addSubview:yangTitle];
    [self.view addSubview:scroller];
    

    
    [self.phoneNumber becomeFirstResponder];
}

-(void) didHitContinue {
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
       
        NSError *error = nil;
        [PFCloud callFunction:@"sendCode" withParameters:@{@"phoneNumber": self.phoneNumber.text} error:&error];
        
        if (error) {
            NSLog(@"%@\n", error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.textCode becomeFirstResponder];
                [self.scrollView scrollRectToVisible:
                 CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)
                                            animated:YES];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            });
        }
    });
}

-(void) didHitKeepGoing {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        PFQuery * check = [PFUser query];
        [check whereKey:@"username" equalTo:self.phoneNumber.text];
        [check setCachePolicy:kPFCachePolicyNetworkOnly];
        
        PFUser *usr = [check getFirstObject];
        BOOL signedUp = [[usr objectForKey:@"signedUp"] boolValue];
        
        NSError *error = nil;
        [PFUser logInWithUsername:usr.username password:[NSString stringWithFormat:@"badapples%d", self.textCode.text.intValue] error:&error];

        if (error) {
            NSLog(@"%@", error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"Invalid code";
                [hud hide:YES afterDelay:1.5f];
                
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            });
        } else {
            if (signedUp) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    
                    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                                    UIUserNotificationTypeBadge |
                                                                    UIUserNotificationTypeSound);
                    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                             categories:nil];
                    
                    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                    
                    //HomeFeedVC *home = [[HomeFeedVC alloc] initWithStyle:UITableViewStylePlain];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[MenuVC home]];
                    nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
                    nav.navigationBar.translucent = NO;
                    
                    MenuVC *menu = [[MenuVC alloc] init];
                    MainVC *drawerController = [[MainVC alloc] initWithCenterViewController:nav leftDrawerViewController:menu];
                    
                    [self presentViewController:drawerController animated:YES completion:nil];
                });
            } else {
                self.theNewUser = [PFUser currentUser];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    [self.firstName becomeFirstResponder];
                    [self.scrollView scrollRectToVisible:
                     CGRectMake(self.scrollView.frame.size.width * 2.0f, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)
                                                animated:YES];
                });
            }
        }
    });
}

-(void) didHitResend{
    [self.phoneNumber becomeFirstResponder];
    [self.scrollView scrollRectToVisible:
     CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)
                                animated:YES];
}

-(void) didHitFinish {
    [self.view endEditing:YES];
    NSString *trimmedFirst = [self.firstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedFirst.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Enter a first name";
        [hud hide:YES afterDelay:1.05f];
        
        [self.firstName becomeFirstResponder];
        
        return;
    }
    
    NSString *trimmedLast = [self.lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedLast.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Enter a last name";
        [hud hide:YES afterDelay:1.05f];
        
        [self.lastName becomeFirstResponder];
        
        return;
    }
    
    NSString *trimmedBlurb = [self.blurb.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedBlurb.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Enter a blurb";
        [hud hide:YES afterDelay:1.05f];
        
        [self.blurb becomeFirstResponder];
        
        return;
    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Would you like to add a profile picture?"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * alert){
                                                          [self actionYes];
                                                      }];
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"Not right now"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * alert){
                                                         [self signUp];
                                                     }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [alertController addAction:actionYes];
    [alertController addAction:actionNo];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeSquare];
    imageCropVC.delegate = self;
    [self presentViewController:imageCropVC animated:YES completion:nil];
}

-(void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    NSData * photoData = UIImageJPEGRepresentation(croppedImage, 0.6f);
    
    if (photoData.length < 10485760)  {
        PFFile * photoFile = [PFFile fileWithData:photoData];
        self.theNewUser[kUserProfilePicture] = photoFile;
    }
    
    [self signUp];
}

- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{
    CGFloat viewWidth = CGRectGetWidth(controller.view.frame);
    CGFloat viewHeight = CGRectGetHeight(controller.view.frame);
    
    CGRect maskRect = CGRectMake(0, (viewHeight - viewWidth) / 2.0f,
                                 viewWidth, viewWidth);
    
    return maskRect;
}

- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller
{
    CGFloat viewWidth = CGRectGetWidth(controller.view.frame);
    CGFloat viewHeight = CGRectGetHeight(controller.view.frame);
    
    CGRect maskRect = CGRectMake(0, (viewHeight - viewWidth) / 2.0f,
                                 viewWidth, viewWidth);
    
    return maskRect;
}

-(void) profilePictureFromCamera:(BOOL) camera {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    
    if (camera) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:ipc animated:YES completion:NULL];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Camera not available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    } else {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
           ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:ipc animated:YES completion:NULL];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Camera not available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void) actionYes {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"Take picture from camera"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * alert){
                                                          [self profilePictureFromCamera:YES];
                                                      }];
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"Choose from library"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * alert){
                                                         [self profilePictureFromCamera:NO];
                                                     }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alertController addAction:actionYes];
    [alertController addAction:actionNo];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) signUp {
    NSString *trimmedFirst = [self.firstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedLast = [self.lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedBlurb = [self.blurb.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    self.theNewUser[@"first"] = trimmedFirst;
    self.theNewUser[@"last"] = trimmedLast;
    self.theNewUser[@"blurb"] = trimmedBlurb;
    self.theNewUser[@"signedUp"] = @YES;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self.theNewUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            [self doPermissions];
        } else {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = error.localizedDescription;
            [hud hide:YES afterDelay:1.5f];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    }];

}


-(void) doPermissions {
    VWWCameraPermission *camera = [VWWCameraPermission permissionWithLabelText:@"Yang needs access to the camera so you can send friends picture or video."];
    
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

                                    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                                                    UIUserNotificationTypeBadge |
                                                                                    UIUserNotificationTypeSound);
                                    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                                             categories:nil];
                                    
                                    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                                    
                                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[MenuVC home]];
                                    
                                    MenuVC *menu = [[MenuVC alloc] init];
                                    MainVC *drawerController = [[MainVC alloc] initWithCenterViewController:nav leftDrawerViewController:menu];
                                    
                                    [self presentViewController:drawerController animated:YES completion:nil];
                                }];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.firstName) {
        [self.formScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (textField == self.lastName) {
        [self.formScroller setContentOffset:CGPointMake(0, self.firstName.frame.origin.y - 8.0f) animated:YES];
    } else if (textField == self.blurb) {
        [self.formScroller setContentOffset:CGPointMake(0, self.lastName.frame.origin.y - 8.0f) animated:YES];
    } else if (textField == self.email) {
        [self.formScroller setContentOffset:CGPointMake(0, self.blurb.frame.origin.y - 8.0f) animated:YES];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (textField == self.phoneNumber) {
        if (newLength == 10 || newLength == 11) {
            [self.continueButton setSelected:YES];
            [self.continueButton setUserInteractionEnabled:YES];
        } else {
            [self.continueButton setSelected:NO];
            [self.continueButton setUserInteractionEnabled:NO];
        }
        
        return newLength <= 10;
    } else if (textField == self.textCode) {
        if (newLength == 4 || newLength == 5) {
            [self.keepGoing setSelected:YES];
            [self.keepGoing setUserInteractionEnabled:YES];
        } else {
            [self.keepGoing setSelected:NO];
            [self.keepGoing setUserInteractionEnabled:NO];
        }
        
        return newLength <= 4;
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.firstName) {
        [self.lastName becomeFirstResponder];
    } else if (textField == self.lastName) {
        [self.blurb becomeFirstResponder];
    } else if (textField == self.blurb) {
        [self.email becomeFirstResponder];
    } else if (textField == self.email) {
        [self didHitFinish];
    }
    return YES;
}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
