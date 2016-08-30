//
//  MainVC.m
//  Yang
//
//  Created by Biggie Smallz on 2/15/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

-(instancetype)initWithCenterViewController:(UIViewController *)centerViewController leftDrawerViewController:(UIViewController *)leftDrawerViewController {
    self = [super initWithCenterViewController:centerViewController leftDrawerViewController:leftDrawerViewController];
    
    if (self) {
        
        self.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
        self.closeDrawerGestureModeMask ^= MMCloseDrawerGestureModePanningDrawerView;
        self.closeDrawerGestureModeMask ^= MMCloseDrawerGestureModePanningCenterView;
        
        [[SharedStateThing sharedManager] setRightDrawerAnimationType:MMDrawerAnimationTypeSlide];
        [[SharedStateThing sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeParallax];
        
        [self setMaximumLeftDrawerWidth:250];
        [self setShowsShadow:NO];
        [self setAnimationVelocity:750];
        [self setPanVelocityXAnimationThreshold:550];
        [self setShouldStretchDrawer:NO];
        
        [self setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
            MMDrawerControllerDrawerVisualStateBlock block;
            
            block = [[SharedStateThing sharedManager]
                     drawerVisualStateBlockForDrawerSide:drawerSide];
            if(block){
                block(drawerController, drawerSide, percentVisible);
            }
        }];
        
        [YUtil setTheDrawer:self];
    }
    
    return self;
}

@end