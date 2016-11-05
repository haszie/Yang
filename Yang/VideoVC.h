//
//  VideoVC.h
//  Yang
//
//  Created by Biggie Smallz on 10/23/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDAVAssetExportSession.h"
#import "MediaPicker.h"

@import AVFoundation;

@interface VideoVC : UIViewController

- (instancetype)initWithVideoUrl:(NSURL *)url;

@property (strong, nonatomic) NSURL *videoUrl;
@property (strong, nonatomic) AVPlayer *avPlayer;
@property (strong, nonatomic) AVPlayerLayer *avPlayerLayer;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *acceptButton;

@property (nonatomic, weak) id <MediaPickerDelegate> delegate;

@end
