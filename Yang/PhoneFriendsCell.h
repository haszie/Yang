//
//  PhoneFriendsCell.h
//  Yang
//
//  Created by Biggie Smallz on 2/18/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProPicIV.h"
#import "YUtil.h"
#import "ProfileInfo.h"

@protocol PhoneFriendsDelegate;

@interface PhoneFriendsCell : UITableViewCell

@property (weak, nonatomic) id<PhoneFriendsDelegate> delegate;
@property (weak, nonatomic) ProPicIV *propic;
@property (weak, nonatomic) UILabel *displayName;
@property (weak, nonatomic) UIButton *followButton;
@property (weak, nonatomic) UIButton *inviteButton;
@property (weak, nonatomic) ProfileInfo *info;

@end

@protocol PhoneFriendsDelegate <NSObject>

-(void) didHitFollowButton:(UIButton *)button forFriendsCell:(PhoneFriendsCell *) cell withInfo:(ProfileInfo *) info;
-(void) didHitInviteButton:(UIButton *)button forFriendsCell:(PhoneFriendsCell *) cell withInfo:(ProfileInfo *) info;

@end