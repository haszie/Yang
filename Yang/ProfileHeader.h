//
//  ProfileHeader.h
//  Yang
//
//  Created by Biggie Smallz on 2/13/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "ProPicIV.h"
#import "YUtil.h"

#define VERT 8.0f
#define HOR 16.0f
#define BTNSIZE 35.0f

@interface ProfileHeader : UIView

-(id)initWithFrame:(CGRect) frame withUser:(PFUser *) user;

@property (nonatomic, weak) PFUser *theUser;
@property (nonatomic, weak) UIButton *sendKarma;
@property (nonatomic, weak) UIButton *editProfile;

@end
