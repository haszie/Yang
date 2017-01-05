//
//  ProfileHeader.m
//  Yang
//
//  Created by Biggie Smallz on 2/13/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "ProfileHeader.h"

@implementation ProfileHeader

-(id)initWithFrame:(CGRect)frame withUser:(PFUser *)user {
    self = [super initWithFrame:frame];
    if (self) {
        self.theUser = user;
        
        [user fetchInBackground];
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.width, frame.size.width, 193.75)];
        back.backgroundColor = [UIColor whiteColor];
        
        CGFloat pro_height = frame.size.width;
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(HOR, pro_height + HOR,  frame.size.width - HOR - HOR, 30.0f)];
        [name setFont:[UIFont fontWithName:@"OpenSans-Light" size:24.0f]];
        [name setTextColor:[UIColor blackColor]];
        name.text = [NSString stringWithFormat:@"%@ %@", self.theUser[@"first"], self.theUser[@"last"]];
        
        UILabel *blurb = [[UILabel alloc] initWithFrame:CGRectMake(HOR, name.frame.origin.y + 24.0f + HOR / 2.0f, frame.size.width - HOR - HOR, 65.5f)];
        [blurb setFont:[UIFont fontWithName:@"OpenSans-Light" size:16.0f]];
        [blurb setTextColor:[UIColor blackColor]];
        blurb.text = self.theUser[@"blurb"];
        blurb.numberOfLines = 2;
        [blurb sizeToFit];
        
        CGFloat btnWidth = (frame.size.width - HOR - HOR - HOR) / 2.0f;
        CGFloat miniLabelWidth = (frame.size.width - HOR - HOR) / 4.0f;
        CGFloat bigLabelOffset = blurb.frame.origin.y + 44.0f + HOR; //name.frame.origin.y + 24.0f + HOR + 24.0f + HOR; // send_karma_btn.frame.origin.y + BTNSIZE + HOR
        CGFloat buttonsOffset = bigLabelOffset + 48.0f;
        
        UILabel *karma = [[UILabel alloc] initWithFrame:
                          CGRectMake(HOR, bigLabelOffset, miniLabelWidth, 16.0f)];
        [karma setFont:[UIFont fontWithName:@"OpenSans-Light" size:18.0f]];
        [karma setTextColor:[UIColor blackColor]];
        karma.text = [NSString stringWithFormat:@"%@", [NSNumberFormatter localizedStringFromNumber:user[@"karma"]
                                                                                        numberStyle:NSNumberFormatterDecimalStyle]];
        
        UILabel *karmaMini = [[UILabel alloc] initWithFrame:CGRectMake(HOR, karma.frame.origin.y + HOR / 2.0f + 14.0f, miniLabelWidth, 16.0f)];
        [karmaMini setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
        [karmaMini setTextColor:[UIColor blackColor]];
        karmaMini.text = @"Karma";
        
//        UILabel *upvote = [[UILabel alloc] initWithFrame:
//                          CGRectMake(HOR + miniLabelWidth * 2.0f, bigLabelOffset, miniLabelWidth, 16.0f)];
//        [upvote setFont:[UIFont fontWithName:@"OpenSans-Light" size:18.0f]];
//        [upvote setTextColor:[UIColor blackColor]];
//        upvote.text = @"0";
//        
//        PFQuery *upvotes = [YUtil upvoteCountForUser:self.theUser];
//        [upvotes countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
//            upvote.text = [NSString stringWithFormat:@"%d", number];
//        }];
//        
//        UILabel *upvoteMini = [[UILabel alloc] initWithFrame:CGRectMake(HOR + miniLabelWidth * 2.0f, karma.frame.origin.y + HOR / 2.0f + 14.0f, miniLabelWidth, 16.0f)];
//        [upvoteMini setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
//        [upvoteMini setTextColor:[UIColor blackColor]];
//        upvoteMini.text = @"Upvotes";

//        UILabel *received = [[UILabel alloc] initWithFrame:
//                          CGRectMake(HOR + miniLabelWidth * 3.0f, bigLabelOffset, miniLabelWidth, 16.0f)];
//        [received setFont:[UIFont fontWithName:@"OpenSans-Light" size:18.0f]];
//        [received setTextColor:[UIColor blackColor]];
//        received.text = @"0";
//        
//        PFQuery *receivedCount = [YUtil receiveCountFor:self.theUser];
//        [receivedCount countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
//            received.text = [NSString stringWithFormat:@"%d", number];
//        }];
//        
//        UILabel *receivedMini = [[UILabel alloc] initWithFrame:CGRectMake(HOR + miniLabelWidth * 3.0f, karma.frame.origin.y + HOR / 2.0f + 14.0f, miniLabelWidth, 16.0f)];
//        [receivedMini setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
//        [receivedMini setTextColor:[UIColor blackColor]];
//        receivedMini.text = @"Received";
        
        [self addSubview:back];
        
        [self addSubview:name];
        [self addSubview:blurb];
        [self addSubview:karma];
        [self addSubview:karmaMini];
//        [self addSubview:upvote];
//        [self addSubview:upvoteMini];
//        [self addSubview:received];
//        [self addSubview:receivedMini];
        
        if ([self.theUser.username isEqualToString:[PFUser currentUser].username]) {
            UIButton *edit_prof_btn = [[UIButton alloc] initWithFrame:
                                       CGRectMake(HOR, buttonsOffset, btnWidth * 2.0f + HOR, BTNSIZE)];
            [edit_prof_btn.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:13.0f]];
            [edit_prof_btn setTitle:@"Edit Profile" forState:UIControlStateNormal];
            [edit_prof_btn setBackgroundColor:[UIColor blackColor]];
            edit_prof_btn.alpha = 1.0f;
            edit_prof_btn.layer.cornerRadius = 3.0f;
            edit_prof_btn.clipsToBounds = YES;
            self.editProfile = edit_prof_btn;
            
            [self addSubview:edit_prof_btn];
        } else {
            UIButton * follow_btn = [[UIButton alloc] initWithFrame:
                                     CGRectMake(HOR, buttonsOffset, btnWidth, BTNSIZE)];
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
            
            [self addSubview:follow_btn];
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                BOOL followStatus = [YUtil currentUserDoesFollowUser:self.theUser];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [follow_btn setSelected:followStatus];
                });
            });
            
            UIButton * send_karma_btn = [[UIButton alloc] initWithFrame:
                                         CGRectMake(HOR + btnWidth + HOR, buttonsOffset, btnWidth, BTNSIZE)];
            [send_karma_btn setTitle:@"Send Karma" forState:UIControlStateNormal];
            [send_karma_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [send_karma_btn setBackgroundColor:[UIColor whiteColor]];
            [send_karma_btn.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:14.0f]];
            send_karma_btn.layer.borderColor = [UIColor blackColor].CGColor;
            send_karma_btn.layer.borderWidth = 1.0f;
            send_karma_btn.layer.cornerRadius = 3.0f;
            send_karma_btn.clipsToBounds = YES;
            self.sendKarma = send_karma_btn;
            [self addSubview:send_karma_btn];
        }
    }
    return self;
}

-(void) didHitFollowButton:(UIButton *) button {
    if (button.isSelected) {
        [YUtil unfollowUserEventually:self.theUser];
    } else {
        [YUtil followUserEventually:self.theUser block:nil];
    }
    [button setSelected:!button.isSelected];
}

@end
