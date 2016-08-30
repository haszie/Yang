//
//  YangRefresh.m
//  JHPullToRefreshExampleProj
//
//  Created by Biggie Smallz on 2/13/16.
//  Copyright © 2016 jhurray. All rights reserved.
//

#import "YangRefresh.h"


@implementation YangRefresh

-(void) setup {
    self.anchorPosition = JHRefreshControlAnchorPositionTop;
    self.rotatingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [self.rotatingView setImage:[UIImage imageNamed:@"yin_yang_spinner"]];
    self.rotatingView.center = CGPointMake(kScreenWidth/2, self.height/2);
    self.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.96 alpha:1.0];
    self.rotatingView.backgroundColor = [UIColor clearColor];
    [self addCABasicAnimationWithKeyPath:@"transform.rotation.z" fromValue:0.0 toValue:2*M_PI];

    [self addSubviewToRefreshAnimationView:self.rotatingView];

}
-(void)handleScrollingOnAnimationView:(UIView *)animationView
                     withPullDistance:(CGFloat)pullDistance
                            pullRatio:(CGFloat)pullRatio
                         pullVelocity:(CGFloat)pullVelocity {
}


-(CALayer *)targetLayer {
    return self.rotatingView.layer;
}

+(CGFloat)height {
    return 70.0;
}

+(NSTimeInterval)animationDuration {
    return 1.2;
}

@end
