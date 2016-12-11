//
//  FriendCell.h
//  Yang
//
//  Created by Biggie Smallz on 1/17/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface FriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *usr_pro;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) PFUser * fwend;
@end
