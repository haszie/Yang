//
//  YUtil.h
//  Yang
//
//  Created by Biggie Smallz on 2/10/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <MMDrawerController/MMDrawerController.h>

#import "YConstants.h"
#import "YCash.h"

@interface YUtil : NSObject

+ (MMDrawerController *) getTheDrawer;
+ (void) setTheDrawer: (MMDrawerController *) theDrawer;

+ (UIColor *)theColor;

+ (void)upvotePostInBackground:(id)post block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
//+ (void)unUpvotePostInBackground:(id)post block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

+ (PFQuery *)upvoteCountForUser:(PFUser *) user;
+ (PFQuery *)sendCountForUser:(PFUser *)user;
+ (PFQuery *)receiveCountFor:(PFUser *)user;

+ (BOOL)userHasProfilePicture:(PFUser *)user;
+ (UIImage *)defaultProfilePicture;

+ (NSString *)firstNameForDisplayName:(NSString *)displayName;

+ (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)followUserEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)followUsersEventually:(NSArray *)users block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unfollowUserEventually:(PFUser *)user;
+ (void)unfollowUsersEventually:(NSArray *)users;
+ (BOOL)currentUserDoesFollowUser:(PFUser *)user;

+ (PFQuery *)queryForActivitiesOnPost:(PFObject *)post cachePolicy:(PFCachePolicy)cachePolicy;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (CGFloat) calcHeight:(PFObject *) post withFrame:(CGRect) frame;

@end