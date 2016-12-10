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
#import "EZCache.h"

#import "ProPicIV.h"

@import AVFoundation;

@interface MediaScreenOverlayVC : UIViewController

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) AVPlayer *avPlayer;
@property (strong, nonatomic) AVPlayerLayer *avPlayerLayer;

@property (strong, nonatomic) ProPicIV * fromUser;
@property (strong, nonatomic) ProPicIV * toUser;

@property (strong, nonatomic) UILabel * fromUserLbl;
@property (strong, nonatomic) UILabel * toUserLbl;

@property (strong, nonatomic) UIView* heada;

@property (weak, nonatomic) PFObject * post;

- (void) show;

@end
