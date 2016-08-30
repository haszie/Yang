//
//  ProPicIV.m
//  Yang
//
//  Created by Biggie Smallz on 2/12/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "ProPicIV.h"

@implementation ProPicIV
@synthesize delegate;

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.datRadius = 3.0f;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.datRadius = 3.0f;
    }
    return self;
}

-(id)initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.datRadius = 3.0f;
    }
    return self;
}

-(id)initWithFrame:(CGRect) frame withUser:(PFUser *) user {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTheUser:user];
        self.datRadius = 3.0f;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.datRadius;
    self.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    if (!self.theUser || !self.theUser[@"propic"]) {
        [self setBackgroundImage:[UIImage imageNamed:@"usr"] forState:UIControlStateNormal];
    }
}

-(void)setTheUser:(PFUser *)theUser {
    _theUser = theUser;
    
    PFFile * pic = [theUser objectForKey:@"propic"];
    [self sd_setImageWithURL:[NSURL URLWithString:pic.url] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(didTapUserPic:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) didTapUserPic:(ProPicIV *) thePic {
    if (delegate && [delegate respondsToSelector:@selector(didTapUserPic:)]) {
        [delegate didTapUserPic:thePic];
    }
}

@end