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
    self.cancelButton.frame = CGRectMake(0, 0, 44, 44);
    
    [self.view addSubview:self.acceptButton];
    [self.acceptButton addTarget:self action:@selector(acceptButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.acceptButton.frame = CGRectMake(self.view.frame.size.width - 44, 0, 44, 44);

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
        UIImage *cancelImage = [UIImage imageNamed:@"cancel.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tintColor = [UIColor redColor];
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

- (UIButton *)acceptButton {
    if(!_acceptButton) {
        UIImage *acceptImage = [UIImage imageNamed:@"check.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tintColor = [UIColor greenColor];
        [button setImage:acceptImage forState:UIControlStateNormal];
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
        NSURL * encodeURL = [self encodeVideo:self.videoUrl];
        [_delegate didFinishWithVideo:encodeURL];
    }
}

-(NSURL *) encodeVideo:(NSURL *) url {
    AVURLAsset *vid = [[AVURLAsset alloc] initWithURL:url options:nil];
    
    SDAVAssetExportSession *encoder = [SDAVAssetExportSession.alloc initWithAsset:vid];
    encoder.outputFileType = AVFileTypeMPEG4;
    
    NSURL *ret  = [[[self applicationDocumentsDirectory]
                    URLByAppendingPathComponent:@"out"] URLByAppendingPathExtension:@"mp4"];
    
    [[NSFileManager defaultManager] removeItemAtURL:ret error:nil];
    
    encoder.outputURL = ret;
    encoder.videoSettings = @
    {
    AVVideoCodecKey: AVVideoCodecH264,
    AVVideoWidthKey: @720,
    AVVideoHeightKey: @1280,
    AVVideoCompressionPropertiesKey: @
        {
        AVVideoAverageBitRateKey: @2000000,
        AVVideoProfileLevelKey: AVVideoProfileLevelH264High40,
        },
    };
    encoder.audioSettings = @
    {
    AVFormatIDKey: @(kAudioFormatMPEG4AAC),
    AVNumberOfChannelsKey: @2,
    AVSampleRateKey: @44100,
    AVEncoderBitRateKey: @128000,
    };
    
    [encoder exportAsynchronouslyWithCompletionHandler:^
     {
         if (encoder.status == AVAssetExportSessionStatusCompleted)
         {
             NSLog(@"Video export succeeded");
         }
         else if (encoder.status == AVAssetExportSessionStatusCancelled)
         {
             NSLog(@"Video export cancelled");
         }
         else
         {
             NSLog(@"Video export failed with error: %@ (%ld)", encoder.error.localizedDescription, encoder.error.code);
         }
     }];
    
    return ret;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
