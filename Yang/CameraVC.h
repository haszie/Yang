//
//  CameraVC.h
//  Yang
//
//  Created by Biggie Smallz on 10/22/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LLSimpleCamera.h"
#import "ViewUtils.h"

#import "ImageVC.h"
#import "VideoVC.h"

@interface CameraVC : UIViewController

@property (strong, nonatomic) LLSimpleCamera *camera;
@property (strong, nonatomic) UILabel *errorLabel;
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;

@end
