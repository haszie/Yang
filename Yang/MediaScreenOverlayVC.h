//
//  MediaScreenOverlayVC.h
//  Yang
//
//  Created by Biggie Smallz on 9/26/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Bolts/Bolts.h>
#import <ParseUI/ParseUI.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "ProPicIV.h"

@interface MediaScreenOverlayVC : UIViewController

@property (weak, nonatomic) PFFile *mediaFile;
@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) ProPicIV * fromUser;
@property (strong, nonatomic) ProPicIV * toUser;

@property (strong, nonatomic) UILabel * fromUserLbl;
@property (strong, nonatomic) UILabel * toUserLbl;

@property (weak, nonatomic) PFObject * post;

- (void) show;

@end
