//
//  YConstants.h
//  Yang
//
//  Created by Biggie Smallz on 2/10/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - NSNotification

extern NSString *const YUtilUserUpvotePostCallbackFinishedNotification;
extern NSString *const YPostVCUserUpvotePostNotification;


# pragma mark - YCash

extern NSString *const kUserIsFollowedByCurrentUser;
extern NSString *const kPostCurrentUserGaveUpvoteKey;
extern NSString *const kPostUpvoteCountKey;
extern NSString *const kPostUpvotersKey;
extern NSString *const kPostCommentCountKey;
extern NSString *const kPostCommentersKey;

# pragma mark - User

extern NSString *const kUserProfilePicture;
extern NSString *const kUserUsername;

# pragma mark - Activity

extern NSString *const kActivityClassKey;
extern NSString *const kActivityTypeKey;
extern NSString *const kActivityPostKey;
extern NSString *const kActivityFromUserKey;
extern NSString *const kActivityToUserKey;
extern NSString *const kActivitySenderKey;
extern NSString *const kActivityReceiverKey;
extern NSString *const kActivityContentKey;
extern NSString *const kActivityTypeUpvote;
extern NSString *const kActivityTypeFollow;
extern NSString *const kActivityTypeComment;

# pragma mark - Post

extern NSString *const kPostClassKey;
extern NSString *const kPostSenderKey;
extern NSString *const kPostReceiverKey;

