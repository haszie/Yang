//
//  PAPPhotoDetailsFooterView.m
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/16/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "NewCommentView.h"

@implementation NewCommentView

@synthesize user_avatar;
@synthesize commentField;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        commentField = [[UITextField alloc] initWithFrame:CGRectMake(48.0f, 8.0f, frame.size.width - 56.0f, 35.0f)];
        commentField.font = [UIFont fontWithName:@"OpenSans" size:13.0f];
        commentField.placeholder = @"Add a comment";
        commentField.returnKeyType = UIReturnKeySend;
        commentField.textColor = [UIColor blackColor];
        commentField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        commentField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        commentField.layer.borderWidth = 0.5f;
        commentField.layer.cornerRadius = 3.0f;
        commentField.layer.masksToBounds = YES;
        commentField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        user_avatar = [[UIImageView alloc] initWithFrame:CGRectMake(8.0f, 8.0f, 35.0f, 35.0f)];
        user_avatar.layer.cornerRadius = 3;
        user_avatar.contentMode = UIViewContentModeScaleAspectFill;
        user_avatar.clipsToBounds = YES;
        
        [self addSubview:user_avatar];
        [self addSubview:commentField];
    }
    return self;
}

-(void) set_user_pic: (NSString *) stringURL {
    [user_avatar sd_setImageWithURL:[NSURL URLWithString:stringURL]];
}

@end
