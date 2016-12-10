//
//  MediaScreenOverlayVC.m
//  Yang
//
//  Created by Biggie Smallz on 9/26/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "MediaScreenOverlayVC.h"

@interface MediaScreenOverlayVC ()
@property (assign, nonatomic) CGFloat containerOffsetYWhenPanBegan;
@property (assign, nonatomic) CGFloat animationDuration;
@property (assign, nonatomic) UIViewAnimationOptions animationStyle;
@end

@implementation MediaScreenOverlayVC

- (id)init
{
    self = [super init];
    if (self) {
        self.animationStyle = UIViewAnimationCurveEaseOut;
        self.animationDuration = 0.18;
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    self.loadVid = false;
    
    self.heada = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 46)];
    self.heada.backgroundColor = [UIColor clearColor];
    
    self.fromUser = [[ProPicIV alloc] initWithFrame:CGRectMake(8, 8, 30, 30)];
    self.toUser = [[ProPicIV alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 38, 8, 30, 30)];
    
    self.fromUserLbl = [[UILabel alloc] initWithFrame:CGRectMake(46, 8, 200, 30)];
    [self.fromUserLbl setFont:[UIFont fontWithName:@"OpenSans" size:15.0f]];
    [self.fromUserLbl setTextColor:[UIColor whiteColor]];

    self.toUserLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 246, 8, 200, 30)];
    [self.toUserLbl setFont:[UIFont fontWithName:@"OpenSans" size:15.0f]];
    [self.toUserLbl setTextColor:[UIColor whiteColor]];
    self.toUserLbl.textAlignment = NSTextAlignmentRight;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.view addGestureRecognizer:pan];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.imageView.userInteractionEnabled = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    
    self.thumbnailView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.thumbnailView.userInteractionEnabled = NO;
    self.thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
    self.thumbnailView.clipsToBounds = YES;

    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.thumbnailView.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.thumbnailView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.thumbnailView addSubview:blurEffectView];
    } else {
        self.thumbnailView.backgroundColor = [UIColor blackColor];
    }
    
    UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(self.thumbnailView.frame.size.width/2.0,
                                   self.thumbnailView.frame.size.height/2.0)];
    [self.thumbnailView addSubview:spinner];
    [spinner startAnimating];
    
    [self.view addSubview:self.thumbnailView];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.heada];
    
    [self.heada addSubview:self.fromUserLbl];
    [self.heada addSubview:self.fromUser];
    [self.heada addSubview:self.toUser];
    [self.heada addSubview:self.fromUserLbl];
    [self.heada addSubview:self.toUserLbl];
    
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)show
{
    if (self.post) {
        
        int amt = [[self.post objectForKey:@"amt"] intValue];
        
        PFFile * imgFile = self.post[@"photo"];
        PFFile * vidFile = self.post[@"video"];
        
        if (imgFile) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgFile.url]];
        } else if (vidFile) {
            if ([[EZCache globalCache] hasCacheForKey:vidFile.url]) {
                NSString* path = [[EZCache globalCache] pathForKey:vidFile.url];
                [self play:[NSURL fileURLWithPath:path]];
            } else {
                self.loadVid = true;
                PFFile * thumbFile = self.post[@"thumbnail"];
                [self.thumbnailView sd_setImageWithURL:[NSURL URLWithString:thumbFile.url]];
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:vidFile.url]];
                    [[EZCache globalCache] setData:data forKey:vidFile.url callback:^{
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            if ([[EZCache globalCache] hasCacheForKey:vidFile.url]) {
                                if (self.loadVid) {
                                    NSString* path = [[EZCache globalCache] pathForKey:vidFile.url];
                                    [self play:[NSURL fileURLWithPath:path]];
                                }
                            }
                        });
                    }];
                });
            }
        }
        
        [self.fromUser setTheUser:self.post[@"giver"]];
        [self.toUser setTheUser:self.post[@"taker"]];
        
        self.fromUserLbl.text = [NSString stringWithFormat:@"%@ → %d", self.post[@"giver"][@"first"], amt];
        self.toUserLbl.text = self.post[@"taker"][@"first"];
    }
    
    [self setHidden:NO duration:self.animationDuration options:self.animationStyle];
}

-(void) play:(NSURL *) url {
    
    self.avPlayer = [AVPlayer playerWithURL:url];
    self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avPlayer currentItem]];
    
    CGRect screenRect = [self.view frame];
    
    self.avPlayerLayer.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    [self.view.layer addSublayer:self.avPlayerLayer];
    [self.view bringSubviewToFront:self.heada];
    [self.avPlayer play];
}

- (IBAction)didTap:(UITapGestureRecognizer *)tapGesture
{
//    BOOL shouldOpen = self.window.frame.origin.y > 0;
//    [self setHidden:!shouldOpen duration:self.animationDuration options:self.animationStyle];
    [[EZCache globalCache] clearCache];

}

- (IBAction)didPan:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translation = [panGesture translationInView:self.view];
    CGPoint velocity = [panGesture velocityInView:self.view];
    BOOL shouldOpen = velocity.y < 0;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.containerOffsetYWhenPanBegan = self.window.frame.origin.y;
            break;
        case UIGestureRecognizerStateChanged: {
            CGRect frame = self.window.bounds;
            frame.origin.y = MAX(0, self.containerOffsetYWhenPanBegan + translation.y);
            self.window.frame = frame;
        } break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            CGFloat targetOffsetY = shouldOpen ? 0 : CGRectGetHeight(self.view.bounds);
            CGFloat distance = fabsf(CGRectGetMinY(self.window.frame) - targetOffsetY);
            CGFloat speed = fabsf(velocity.y);
            NSTimeInterval duration = distance/speed;
            [self setHidden:!shouldOpen duration:duration options:self.animationStyle];
        } break;
        default:
            break;
    }
}

- (void)setHidden:(BOOL)hidden duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options
{
    if (hidden) {
        self.loadVid = false;
        [self.avPlayer pause];
        [self.avPlayerLayer removeFromSuperlayer];
        self.avPlayer = nil;
        [self.imageView setImage:nil];
        [self.thumbnailView setImage:nil];
    }
    [UIView animateWithDuration:self.animationDuration delay:0 options:options animations:^{
        CGRect frame = self.window.bounds;
        frame.origin.y = !hidden ? 0 : CGRectGetHeight(self.view.bounds);
        self.window.frame = frame;
    } completion:NULL];
}

- (UIWindow *)window
{
    return self.view.window;
}

@end
