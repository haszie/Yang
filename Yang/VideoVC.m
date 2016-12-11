//
//  VideoVC.m
//  Yang
//
//  Created by Biggie Smallz on 10/23/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "VideoVC.h"

@interface VideoVC ()

@end

@implementation VideoVC

- (instancetype)initWithVideoUrl:(NSURL *)url {
    self = [super init];
    if(self) {
        _videoUrl = url;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // the video player
    self.avPlayer = [AVPlayer playerWithURL:self.videoUrl];
    self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    //self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view setBackgroundColor:[UIColor blackColor] ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avPlayer currentItem]];
    
    CGRect screenRect = [self.view frame];
    
    self.avPlayerLayer.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    [self.view.layer addSublayer:self.avPlayerLayer];
    
    // cancel button
    [self.view addSubview:self.cancelButton];
    [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.frame = CGRectMake(5, self.view.frame.size.height - 44 - 5, 44, 44);
    
    [self.view addSubview:self.acceptButton];
    [self.acceptButton addTarget:self action:@selector(acceptButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.acceptButton.frame = CGRectMake(self.view.frame.size.width - 44, self.view.frame.size.height - 44 - 5, 44, 44);

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.avPlayer play];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIButton *)cancelButton {
    if(!_cancelButton) {
        UIImage *cancelImage = [UIImage imageNamed:@"cancel"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setImage:cancelImage forState:UIControlStateNormal];
        button.tintColor = [UIColor whiteColor];
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


- (UIButton *)acceptButton {
    if(!_acceptButton) {
        UIImage *acceptImage = [UIImage imageNamed:@"check"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setImage:acceptImage forState:UIControlStateNormal];
        button.tintColor = [UIColor whiteColor];
        button.imageView.clipsToBounds = NO;
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        button.layer.shadowColor = [UIColor blackColor].CGColor;
        button.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        button.layer.shadowOpacity = 0.4f;
        button.layer.shadowRadius = 1.0f;
        button.clipsToBounds = NO;
        
        _acceptButton = button;
    }
    
    return _acceptButton;
}

- (void)acceptButtonPressed:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(didFinishWithVideo:)]) {
        [self export:self.videoUrl];
    }
}

#pragma mark SCAssetDelegate

- (void)assetExportSessionDidProgress:(SCAssetExportSession *)assetExportSession {
    float progress = assetExportSession.progress;
    if (self.hud) {
        self.hud.progress = progress;
    }
}

-(void) export: (NSURL *) url {
    
    AVURLAsset *vid = [[AVURLAsset alloc] initWithURL:url options:nil];
    self.outputURL  = [[[self applicationDocumentsDirectory]
                    URLByAppendingPathComponent:@"out"] URLByAppendingPathExtension:@"mp4"];

    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:vid];
    exportSession.videoConfiguration.preset = SCPresetMediumQuality;
    exportSession.audioConfiguration.preset = SCPresetMediumQuality;
    exportSession.videoConfiguration.maxFrameRate = 40;
    exportSession.outputUrl = self.outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.delegate = self;

    CFTimeInterval time = CACurrentMediaTime();
    __weak typeof(self) wSelf = self;
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeAnnularDeterminate;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        __strong typeof(self) strongSelf = wSelf;
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        if (!exportSession.cancelled) {
            NSLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
        }
        
        if (strongSelf) {
            [self.hud hide:YES];
        }

        NSError *error = exportSession.error;
        if (exportSession.cancelled) {
            NSLog(@"Export was cancelled");
        } else if (error == nil) {
            [_delegate didFinishWithVideo:self.outputURL];

        } else {
            if (!exportSession.cancelled) {
                [[[UIAlertView alloc] initWithTitle:@"Failed to save" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
    }];
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
