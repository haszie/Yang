//
//  ProPicIV.h
//  Yang
//
//  Created by Biggie Smallz on 2/12/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <SDWebImage/UIButton+WebCache.h>

@protocol ProPicDelegate;

@interface ProPicIV : UIButton

-(id)initWithFrame:(CGRect) frame withUser:(PFUser *) user;

@property (nonatomic, weak) PFUser *theUser;
@property (nonatomic,weak) id <ProPicDelegate> delegate;
@property (nonatomic) CGFloat datRadius;

@end

@protocol ProPicDelegate <NSObject>

-(void) didTapUserPic:(ProPicIV *) thePic;

@end