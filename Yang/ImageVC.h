//
//  ImageVC.h
//  Yang
//
//  Created by Biggie Smallz on 10/23/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewUtils.h"
#import "UIImage+Crop.h"

#import "MediaPicker.h"

@interface ImageVC : UIViewController

- (instancetype) initWithImage:(UIImage *) image;

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *acceptButton;

@property (nonatomic, weak) id <MediaPickerDelegate> delegate;

@end
