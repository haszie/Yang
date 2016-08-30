//
//  FriendCell.m
//  Yang
//
//  Created by Biggie Smallz on 1/17/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell

- (void)awakeFromNib {

    _usr_pro.layer.cornerRadius = 5;
    _usr_pro.clipsToBounds = YES;
    _usr_pro.contentMode = UIViewContentModeScaleAspectFill;
}

@end
