//
//  ShowUpdViewController.h
//  Yang
//
//  Created by Biggie Smallz on 12/10/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "FriendCell.h"
#import "YUtil.h"

@interface ShowUpdVC : PFQueryTableViewController

- (id)initWithPFObject: (PFObject *) obj;

@property (strong, nonatomic) PFObject *post;

@end
