//
//  CameraVC.m
//  Yang
//
//  Created by Biggie Smallz on 10/22/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "CameraVC.h"

@interface CameraVC ()

@end

@implementation CameraVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    // ----- initialize camera -------- //
    
    // create camera vc
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPreset1280x720
                                                 position:LLCameraPositionRear
                                             videoEnabled:YES];
    
    // attach to a view controller
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    
    // read: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
    // you probably will want to set this to YES, if you are going view the image outside iOS.
    self.camera.fixOrientationAfterCapture = NO;
    
    // take the required actions on a device change
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
                
        // device changed, check if flash is available
        if([camera isFlashAvailable]) {
            weakSelf.flashButton.hidden = NO;
            
            if(camera.flash == LLCameraFlashOff) {
                weakSelf.flashButton.selected = NO;
            }
            else {
                weakSelf.flashButton.selected = YES;
            }
        }
        else {
            weakSelf.flashButton.hidden = YES;
        }
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        NSLog(@"Camera error: %@", error);
        
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission ||
               error.code == LLSimpleCameraErrorCodeMicrophonePermission) {
                
                if(weakSelf.errorLabel) {
                    [weakSelf.errorLabel removeFromSuperview];
                }
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = @"We need permission for the camera.\nPlease go to your settings.";
                label.numberOfLines = 2;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0f];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                label.center = CGPointMake(screenRect.size.width / 2.0f, screenRect.size.height / 2.0f);
                weakSelf.errorLabel = label;
                [weakSelf.view addSubview:weakSelf.errorLabel];
            }
        }
    }];
    
    // ----- camera buttons -------- //
    
    // snap button to capture image
    self.snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.snapButton.frame = CGRectMake(0, 0, 70.0f, 70.0f);
    self.snapButton.clipsToBounds = YES;
    self.snapButton.layer.cornerRadius = self.snapButton.frame.size.width / 2.0f;
    self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.snapButton.layer.borderWidth = 2.0f;
    self.snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    self.snapButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.snapButton.layer.shouldRasterize = YES;
    UILongPressGestureRecognizer * pressLong =  [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(snapButtonLongPress:)];
    [self.snapButton addGestureRecognizer:pressLong];
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.snapButton];
    
    // button to toggle flash
    self.flashButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.flashButton.frame = CGRectMake(0, 0, 16.0f + 20.0f, 24.0f + 20.0f);
    self.flashButton.tintColor = [UIColor whiteColor];
    [self.flashButton setImage:[UIImage imageNamed:@"camera-flash.png"] forState:UIControlStateNormal];
    self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    
    if([LLSimpleCamera isFrontCameraAvailable] && [LLSimpleCamera isRearCameraAvailable]) {
        // button to toggle camera positions
        self.switchButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.switchButton.frame = CGRectMake(0, 0, 29.0f + 20.0f, 22.0f + 20.0f);
        self.switchButton.tintColor = [UIColor whiteColor];
        [self.switchButton setImage:[UIImage imageNamed:@"camera-switch.png"] forState:UIControlStateNormal];
        self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        [self.switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.switchButton];
    }
    
    // cancel button
    [self.view addSubview:self.cancelButton];
    [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.frame = CGRectMake(0, 0, 44, 44);
    
    // video record time
    self.recordPV = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    self.recordPV.frame = CGRectMake(0, 0, self.view.width, 3);
    self.recordPV.tintColor = [UIColor colorWithRed:178.0f/255.0f green:34.0f/255.0f blue:34.0f/255.0f alpha:1.0f];
//    self.recordPV.alpha = 0.8f;
//    self.recordPV.layer.shadowRadius  = 2.5f;
//    self.recordPV.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
//    self.recordPV.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
//    self.recordPV.layer.shadowOpacity = 0.9f;
//    self.recordPV.layer.masksToBounds = NO;
    
//    [self.recordTimer setProgress:0.5f animated:YES];
    [self.view addSubview:self.recordPV];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // start the camera
    [self.camera start];
}

- (void)switchButtonPressed:(UIButton *)button
{
    [self.camera togglePosition];
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark MediaPicker methods

-(void)didFinishWithVideo:(NSURL *)videoPath {
    if (_delegate && [_delegate respondsToSelector:@selector(didFinishWithImage:)]) {
        [_delegate didFinishWithVideo:videoPath];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didFinishWithImage:(UIImage *)image {
    if (_delegate && [_delegate respondsToSelector:@selector(didFinishWithImage:)]) {
        [_delegate didFinishWithImage:image];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)flashButtonPressed:(UIButton *)button
{
    if(self.camera.flash == LLCameraFlashOff) {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOn];
        if(done) {
            self.flashButton.selected = YES;
            self.flashButton.tintColor = [UIColor yellowColor];
        }
    }
    else {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOff];
        if(done) {
            self.flashButton.selected = NO;
            self.flashButton.tintColor = [UIColor whiteColor];
        }
    }
}

- (void) startTimer {
    self.time = 0.0f;
    self.recordTimer = [NSTimer scheduledTimerWithTimeInterval: 0.05f
                                                        target: self
                                                      selector: @selector(updateTimer)
                                                      userInfo: nil
                                                       repeats: YES];
}

- (void) stopTimer {
    if ([self.recordTimer isValid]) {
        [self.recordTimer invalidate];
    }
    self.recordTimer = nil;
}


-(void) updateTimer
{
    if(self.time >= 8.0f)
    {
        [self stopTimer];
        self.recordPV.progress = 0;
        [self endRecording];
    }
    else
    {
        self.time += 0.05;
        self.recordPV.progress = self.time / 8.0f;
    }
}


-(void) snapButtonLongPress: (UILongPressGestureRecognizer *) gesture {
    NSInteger state = gesture.state;
    
    switch (state) {
        case UIGestureRecognizerStateChanged: break;
        case UIGestureRecognizerStateBegan:
        {
            
            self.cancelButton.hidden = YES;
            self.flashButton.hidden = YES;
            self.switchButton.hidden = YES;
            
            self.snapButton.layer.borderColor = [UIColor redColor].CGColor;
            self.snapButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
            
            // start recording
            NSURL *outputURL = [[[self applicationDocumentsDirectory]
                                 URLByAppendingPathComponent:@"flick"] URLByAppendingPathExtension:@"mov"];
            
            
            [self.camera startRecordingWithOutputUrl:outputURL];
            [self startTimer];
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self stopTimer];
            self.recordPV.progress = 0;
            [self endRecording];
            
            break;
        }
    }
}

-(void) endRecording {
    self.cancelButton.hidden = NO;
    self.flashButton.hidden = NO;
    self.switchButton.hidden = NO;
    
    self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    __weak typeof(self) weakSelf = self;
    
    [self.camera stopRecording:^(LLSimpleCamera *camera, NSURL *outputFileUrl, NSError *error) {
        VideoVC *vvc = [[VideoVC alloc] initWithVideoUrl:outputFileUrl];
        vvc.delegate = self;
        [weakSelf presentViewController:vvc animated:NO completion:nil];
    }];
}

- (void)snapButtonPressed:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
            ImageVC *ivc = [[ImageVC alloc] initWithImage:image];
            ivc.delegate = self;
            [weakSelf presentViewController:ivc animated:NO completion:nil];
        }
        else {
            NSLog(@"An error has occured: %@", error);
        }
    } exactSeenImage:YES];
}

/* other lifecycle methods */

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.camera.view.frame = self.view.contentBounds;
    
    self.snapButton.center = self.view.contentCenter;
    self.snapButton.bottom = self.view.height - 15.0f;
    
    self.flashButton.center = self.view.contentCenter;
    self.flashButton.top = 5.0f;
    
    self.switchButton.top = 5.0f;
    self.switchButton.right = self.view.width - 5.0f;

    self.cancelButton.top = 5.0f;
    self.cancelButton.left = 5.0f;
    [self.cancelButton setTintColor:[UIColor whiteColor]];
    
}

- (UIButton *)cancelButton {
    if(!_cancelButton) {
        UIImage *cancelImage = [UIImage imageNamed:@"cancel.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tintColor = [UIColor whiteColor];
        [button setImage:cancelImage forState:UIControlStateNormal];
        button.imageView.clipsToBounds = NO;
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        button.layer.shadowColor = [UIColor blackColor].CGColor;
        button.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        button.layer.shadowOpacity = 0.4f;
        button.layer.shadowRadius = 1.0f;
        button.clipsToBounds = NO;
        
        _cancelButton = button;
    }
    
    return _cancelButton;
}

- (void)cancelButtonPressed:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
