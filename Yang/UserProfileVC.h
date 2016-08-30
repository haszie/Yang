//
//  UserProfileVC.h
//  Yang
//
//  Created by Biggie Smallz on 2/12/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "FeedVC.h"
#import "ProfileHeader.h"
#import "SendKarmaVC.h" 
#import "EditProfileVC.h"

@interface UserProfileVC : FeedVC

- (id)initWithUser:(PFUser *) aUser;

@property (nonatomic, strong) PFUser *theUser;
@property BOOL addMenuButton;

@end
