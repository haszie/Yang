//
//  PhoneFriendsCell.m
//  Yang
//
//  Created by Biggie Smallz on 2/18/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "PhoneFriendsCell.h"

@implementation PhoneFriendsCell
@synthesize delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        ProPicIV *propic = [[ProPicIV alloc] initWithFrame:CGRectMake(8.0f, 8.0f, 55.0f, 55.0f)];
        self.propic = propic;
        [self addSubview:propic];
        
        UILabel *displayName = [[UILabel alloc] initWithFrame:CGRectMake(8.0f + 55.0f + 8.0f, 23.0f, 200.0, 24.0f)];
        [displayName setFont:[UIFont fontWithName:@"OpenSans" size:16.0f]];
        [displayName setTextColor:[UIColor blackColor]];
        self.displayName = displayName;
        [self addSubview:displayName];
        
        UIButton * follow_btn = [[UIButton alloc] init];
        [follow_btn setTitle:@"Follow" forState:UIControlStateNormal];
        [follow_btn setTitle:@"Following ✓" forState:UIControlStateSelected];
        [follow_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [follow_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [follow_btn addTarget:self action:@selector(didHitFollowButton:) forControlEvents:UIControlEventTouchUpInside];
        [follow_btn.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:13.0f]];
        [follow_btn setBackgroundImage:[YUtil imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [follow_btn setBackgroundImage:[YUtil imageWithColor:[YUtil theColor]] forState:UIControlStateSelected];
        follow_btn.layer.borderColor = [UIColor blackColor].CGColor;
        follow_btn.layer.borderWidth = 1.0f;
        follow_btn.layer.cornerRadius = 3.0f;
        follow_btn.clipsToBounds = YES;
        follow_btn.hidden = YES;
        self.followButton = follow_btn;
        [self addSubview:follow_btn];
        
        UIButton * inviteButton = [[UIButton alloc] init];
        [inviteButton setTitle:@"Invite" forState:UIControlStateNormal];
        [inviteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [inviteButton setBackgroundColor:[UIColor whiteColor]];
        [inviteButton addTarget:self action:@selector(didHitInviteButton:) forControlEvents:UIControlEventTouchUpInside];
        [inviteButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:13.0f]];
        inviteButton.layer.borderColor = [UIColor blackColor].CGColor;
        inviteButton.layer.borderWidth = 1.0f;
        inviteButton.layer.cornerRadius = 3.0f;
        inviteButton.clipsToBounds = YES;
        inviteButton.hidden = YES;
        self.inviteButton = inviteButton;
        [self addSubview:inviteButton];
        
    }
    return self;
}

-(void) didHitFollowButton:(UIButton *)button {
    if (delegate && [delegate respondsToSelector:@selector(didHitFollowButton:forFriendsCell:withInfo:)]) {
        [delegate didHitFollowButton:button forFriendsCell:self withInfo:self.info];
    }
}

-(void) didHitInviteButton:(UIButton *)button {
    if (delegate && [delegate respondsToSelector:@selector(didHitInviteButton:forFriendsCell:withInfo:)]) {
        [delegate didHitInviteButton:button forFriendsCell:self withInfo:self.info];
    }
}

@end