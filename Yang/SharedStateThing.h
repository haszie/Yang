//
//  SharedStateThing.h
//  Board
//
//  Created by Biggie Smallz on 8/18/15.
//  Copyright (c) 2015 Hasz Enterprises, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MMDrawerController/MMDrawerVisualState.h>

@interface SharedStateThing : NSObject

typedef NS_ENUM(NSInteger, MMDrawerAnimationType){
    MMDrawerAnimationTypeNone,
    MMDrawerAnimationTypeSlide,
    MMDrawerAnimationTypeSlideAndScale,
    MMDrawerAnimationTypeSwingingDoor,
    MMDrawerAnimationTypeParallax,
};

@property (nonatomic,assign) MMDrawerAnimationType leftDrawerAnimationType;
@property (nonatomic,assign) MMDrawerAnimationType rightDrawerAnimationType;

+ (SharedStateThing *)sharedManager;

-(MMDrawerControllerDrawerVisualStateBlock)drawerVisualStateBlockForDrawerSide:(MMDrawerSide)drawerSide;

@end
