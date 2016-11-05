//
//  CameraVC.h
//  Yang
//
//  Created by Biggie Smallz on 10/22/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Bolts/Bolts.h>
#import <ParseUI/ParseUI.h>

#import "LLSimpleCamera.h"
#import "ViewUtils.h"

#import "ImageVC.h"
#import "VideoVC.h"

#import "MediaPicker.h"

@interface CameraVC : UIViewController<MediaPickerDelegate>

@property (strong, nonatomic) LLSimpleCamera *camera;
@property (strong, nonatomic) UILabel *errorLabel;
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIProgressView *recordPV;
@property (strong, nonatomic) NSTimer *recordTimer;
@property float time;

@property (nonatomic, weak) id <MediaPickerDelegate> delegate;

@end
