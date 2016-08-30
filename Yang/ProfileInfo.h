//
//  ProfileInfo.h
//  Yang
//
//  Created by Biggie Smallz on 2/18/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#import "APContact.h"

@interface ProfileInfo : NSObject

@property BOOL isComplete;
@property BOOL isYangActive;

@property (strong, nonatomic) PFUser *theUser;
@property (strong, nonatomic) APContact *contact;

@end
