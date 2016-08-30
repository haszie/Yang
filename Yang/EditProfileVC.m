//
//  EditProfileVC.m
//  Yang
//
//  Created by Biggie Smallz on 2/23/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "EditProfileVC.h"

@interface EditProfileVC ()

@end

@implementation EditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"Edit Profile";

    UILabel *signUpHelp = [[UILabel alloc] initWithFrame:
                           CGRectMake(32.0f, 16.0f, self.view.frame.size.width - 64.0f, 88.0f)];
    [signUpHelp setFont:[UIFont fontWithName:@"OpenSans" size:18.0f]];
    [signUpHelp setTextColor:[UIColor blackColor]];
    signUpHelp.numberOfLines = 0;
    signUpHelp.text = @"Hit back at anytime to cancel.";
    [signUpHelp setTextAlignment:NSTextAlignmentJustified];
    [signUpHelp sizeToFit];
    
    UITextField *firstName = [[UITextField alloc] initWithFrame:
                              CGRectMake(0, signUpHelp.frame.origin.y + signUpHelp.frame.size.height + 16.0f, self.view.frame.size.width, 50.0f)];
    [firstName setBackgroundColor:[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0f]];
    [firstName setFont:[UIFont fontWithName:@"OpenSans" size:20.0f]];
    [firstName setPlaceholder:@"First"];
    [firstName setTextColor:[UIColor blackColor]];
    [firstName setReturnKeyType:UIReturnKeyNext];
    UIView *spacer_again = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32.0f, 60.0f)];
    [firstName setLeftViewMode:UITextFieldViewModeAlways];
    [firstName setLeftView:spacer_again];
    firstName.delegate = self;
    self.firstName = firstName;
    
    UITextField *lastName = [[UITextField alloc] initWithFrame:
                             CGRectMake(0, firstName.frame.origin.y + firstName.frame.size.height + 16.0f, self.view.frame.size.width, 50.0f)];
    [lastName setBackgroundColor:[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0f]];
    [lastName setFont:[UIFont fontWithName:@"OpenSans" size:20.0f]];
    [lastName setPlaceholder:@"Last"];
    [lastName setTextColor:[UIColor blackColor]];
    [lastName setReturnKeyType:UIReturnKeyNext];
    UIView *spacer_again_lol = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32.0f, 60.0f)];
    [lastName setLeftViewMode:UITextFieldViewModeAlways];
    [lastName setLeftView:spacer_again_lol];
    lastName.delegate = self;
    self.lastName = lastName;
    
    UITextField *blurb = [[UITextField alloc] initWithFrame:
                          CGRectMake(0, lastName.frame.origin.y + lastName.frame.size.height + 16.0f, self.view.frame.size.width, 50.0f)];
    [blurb setBackgroundColor:[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0f]];
    [blurb setFont:[UIFont fontWithName:@"OpenSans" size:20.0f]];
    [blurb setPlaceholder:@"Blurb about yourself"];
    [blurb setTextColor:[UIColor blackColor]];
    [blurb setReturnKeyType:UIReturnKeyNext];
    UIView *spacer_lol = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32.0f, 60.0f)];
    [blurb setLeftViewMode:UITextFieldViewModeAlways];
    [blurb setLeftView:spacer_lol];
    blurb.delegate = self;
    self.blurb = blurb;
    
    UITextField *email = [[UITextField alloc] initWithFrame:
                          CGRectMake(0, blurb.frame.origin.y + blurb.frame.size.height + 16.0f, self.view.frame.size.width, 50.0f)];
    [email setBackgroundColor:[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0f]];
    [email setFont:[UIFont fontWithName:@"OpenSans" size:20.0f]];
    [email setPlaceholder:@"Email (optional)"];
    [email setTextColor:[UIColor blackColor]];
    [email setReturnKeyType:UIReturnKeyDone];
    UIView *spacer_last = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32.0f, 60.0f)];
    [email setLeftViewMode:UITextFieldViewModeAlways];
    [email setLeftView:spacer_last];
    email.delegate = self;
    self.email = email;

    UIButton *camera = [[UIButton alloc] initWithFrame:
                        CGRectMake(32.0f, email.frame.origin.y + email.frame.size.height + 24.0f, self.view.frame.size.width - 64.0f, 50.0f)];
    [camera addTarget:self action:@selector(didHitCam) forControlEvents:UIControlEventTouchUpInside];
    [camera.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:20.0f]];
    [camera setBackgroundColor:[UIColor blackColor]];
    [camera setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [camera setTitle:@"New Profile Picture" forState:UIControlStateNormal];
    [camera setAdjustsImageWhenHighlighted:NO];
    self.camera = camera;
    
    UIButton *finish = [[UIButton alloc] initWithFrame:
                        CGRectMake(32.0f, camera.frame.origin.y + camera.frame.size.height + 24.0f, self.view.frame.size.width - 64.0f, 50.0f)];
    [finish addTarget:self action:@selector(didHitSave) forControlEvents:UIControlEventTouchUpInside];
    [finish.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:20.0f]];
    [finish setBackgroundColor:[UIColor colorWithRed:32.0/255.0f green:164.0/255.0f blue:0.0/255.0f alpha:1.0f]];
    [finish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finish setTitle:@"Save" forState:UIControlStateNormal];
    [finish setAdjustsImageWhenHighlighted:NO];
    self.finish = finish;
    
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [scroller setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 50.0f)];
    [scroller setScrollEnabled:YES];
    [scroller setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    scroller.bounces = YES;
    self.scroller = scroller;
    
    [scroller addSubview:signUpHelp];
    [scroller addSubview:firstName];
    [scroller addSubview:lastName];
    [scroller addSubview:blurb];
    [scroller addSubview:email];
    [scroller addSubview:camera];
    [scroller addSubview:finish];
    
    [self.view addSubview:scroller];
    
    _firstName.text = [PFUser currentUser][@"first"];
    _lastName.text = [PFUser currentUser][@"last"];
    _blurb.text = [PFUser currentUser][@"blurb"];
    _email.text = [PFUser currentUser][@"email"];
   
    [_firstName becomeFirstResponder];
}

-(void) didHitSave {
    PFUser *usa = [PFUser currentUser];
    
    if (usa) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        [self.view endEditing:YES];
        NSString *trimmedFirst = [self.firstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (trimmedFirst.length == 0) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"Enter a first name";
            [hud hide:YES afterDelay:1.05f];
            
            [self.firstName becomeFirstResponder];
            
            return;
        }
        
        NSString *trimmedLast = [self.lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (trimmedLast.length == 0) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"Enter a last name";
            [hud hide:YES afterDelay:1.05f];
            
            [self.lastName becomeFirstResponder];
            
            return;
        }
        
        NSString *trimmedBlurb = [self.blurb.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (trimmedBlurb.length == 0) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"Enter a blurb";
            [hud hide:YES afterDelay:1.05f];
            
            [self.blurb becomeFirstResponder];
            
            return;
        }

        NSString *trimmedEmail = [self.email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (trimmedEmail != 0) usa[@"email"] = self.email.text;

        usa[@"first"] = trimmedFirst;
        usa[@"last"] = trimmedLast;
        usa[@"blurb"] = trimmedBlurb;
        
        if (self.profileImage) {
            NSData * photoData = UIImageJPEGRepresentation(self.profileImage, 0.6f);
            
            if (photoData.length < 10485760)  {
                PFFile * photoFile = [PFFile fileWithData:photoData];
                usa[@"propic"] = photoFile;
            }
        }
        
        [usa saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                hud.mode = MBProgressHUDModeCustomView;
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
                hud.labelText = @"Success!";
                [hud hide:YES afterDelay:1.05f];
            } else {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = error.localizedDescription;
                [hud hide:YES afterDelay:1.05f];
            }
        }];
    }
}

-(void) didHitCam {
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeSquare];
    imageCropVC.delegate = self;
    [self presentViewController:imageCropVC animated:YES completion:nil];
}

-(void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    self.profileImage = croppedImage;
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

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.firstName) {
        [self.scroller setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (textField == self.lastName) {
        [self.scroller setContentOffset:CGPointMake(0, self.firstName.frame.origin.y - 8.0f) animated:YES];
    } else if (textField == self.blurb) {
        [self.scroller setContentOffset:CGPointMake(0, self.lastName.frame.origin.y - 8.0f) animated:YES];
    } else if (textField == self.email) {
        [self.scroller setContentOffset:CGPointMake(0, self.blurb.frame.origin.y - 8.0f) animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.firstName) {
        [self.lastName becomeFirstResponder];
    } else if (textField == self.lastName) {
        [self.blurb becomeFirstResponder];
    } else if (textField == self.blurb) {
        [self.email becomeFirstResponder];
    }
    return YES;
}

@end
