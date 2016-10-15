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
    
    UIView * header_bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 46)];
    header_bg.backgroundColor = [UIColor whiteColor];
    header_bg.alpha = 0.777f;
    
    self.fromUser = [[ProPicIV alloc] initWithFrame:CGRectMake(8, 8, 30, 30)];
    self.toUser = [[ProPicIV alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 38, 8, 30, 30)];
    
    self.fromUserLbl = [[UILabel alloc] initWithFrame:CGRectMake(46, 8, 200, 30)];
    [self.fromUserLbl setFont:[UIFont fontWithName:@"OpenSans" size:15.0f]];
    
    self.toUserLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 246, 8, 200, 30)];
    [self.toUserLbl setFont:[UIFont fontWithName:@"OpenSans" size:15.0f]];
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
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:header_bg];
    [self.view addSubview:self.fromUserLbl];
    [self.view addSubview:self.fromUser];
    [self.view addSubview:self.toUser];
    [self.view addSubview:self.fromUserLbl];
    [self.view addSubview:self.toUserLbl];
 
}

- (void)show
{
    
    if (self.mediaFile.url) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.mediaFile.url]];
    }
    
    if (self.post) {
        
        int amt = [[self.post objectForKey:@"amt"] intValue];

        [self.fromUser setTheUser:self.post[@"giver"]];
        [self.toUser setTheUser:self.post[@"taker"]];
        
        self.fromUserLbl.text = [NSString stringWithFormat:@"%@ → %d", self.post[@"giver"][@"first"], amt];
        self.toUserLbl.text = self.post[@"taker"][@"first"];
    }
    
    [self setHidden:NO duration:self.animationDuration options:self.animationStyle];
}

- (IBAction)didTap:(UITapGestureRecognizer *)tapGesture
{
    BOOL shouldOpen = self.window.frame.origin.y > 0;
    [self setHidden:!shouldOpen duration:self.animationDuration options:self.animationStyle];
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
