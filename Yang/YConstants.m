//
//  YConstants.m
//  Yang
//
//  Created by Biggie Smallz on 2/10/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "YConstants.h"

#pragma mark - NSNotification

NSString *const YUtilUserUpvotePostCallbackFinishedNotification                           = @"com.hasz.Yang.utils.userUpvotePostCallbackFinishedNotification";
NSString *const YPostVCUserUpvotePostNotification                                         = @"com.hasz.Yang.General.PostVC.userUpvotePostNotification";

# pragma mark - YCash

NSString *const kPostCurrentUserGaveUpvoteKey                         = @"currentUserGaveUpvote";
NSString *const kPostUpvoteCountKey                                   = @"postUpvoteCount";
NSString *const kPostUpvotersKey                                     = @"postUpvoters";
NSString *const kPostCommentCountKey                                = @"postCommentCount";
NSString *const kPostCommentersKey                                  = @"postCommenters";
NSString *const kUserIsFollowedByCurrentUser                        = @"userIsFollowedByCurrentUser";

# pragma mark - User

NSString *const kUserProfilePicture         = @"propic";
NSString *const kUserUsername               = @"username";

# pragma mark - Activity

NSString *const kActivityClassKey                           = @"activity";
NSString *const kActivityTypeKey                            = @"type";
NSString *const kActivityPostKey                            = @"post";
NSString *const kActivityFromUserKey                        = @"fromUser";
NSString *const kActivityToUserKey                          = @"toUser";
NSString *const kActivityContentKey                         = @"content";
NSString *const kActivityTypeUpvote                         = @"upvote";
NSString *const kActivityTypeFollow                         = @"follow";
NSString *const kActivityTypeComment                        = @"comment";
NSString *const kActivitySenderKey                          = @"sender";
NSString *const kActivityReceiverKey                        = @"receiver";

# pragma mark - Post

NSString *const kPostClassKey                = @"post";
NSString *const kPostSenderKey           = @"giver";
NSString *const kPostReceiverKey         = @"taker";