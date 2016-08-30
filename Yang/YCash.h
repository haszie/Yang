//
//  YCash.h
//  
//
//  Created by Biggie Smallz on 2/10/16.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#import "YConstants.h"

@interface YCash : NSObject

+ (id)sharedCache;

- (void)clear;
- (void)setAttributesForPost:(PFObject *)post upvoters:(NSArray *)upvoters commenters:(NSArray *)commenters upvotedByCurrentUser:(BOOL)upvotedByCurrentUser;
- (NSDictionary *)attributesForPost:(PFObject *)post;
- (NSNumber *)upvoteCountForPost:(PFObject *)post;
- (NSNumber *)commentCountForPost:(PFObject *)post;
- (NSArray *)upvotersForPost:(PFObject *)post;
- (NSArray *)commentersForPost:(PFObject *)post;
- (void)setCurrentUserGaveUpvoteForPost:(PFObject *)post upvoted:(BOOL)upvote;
- (BOOL)currentUserGaveUpvoteForPost:(PFObject *)post;
- (void)incrementUpvoterCountForPost:(PFObject *)post;
- (void)decrementUpvoterCountForPost:(PFObject *)post;
- (void)incrementCommentCountForPost:(PFObject *)post;
- (void)decrementCommentCountForPost:(PFObject *)post;

- (NSDictionary *)attributesForUser:(PFUser *)user;
- (BOOL)followStatusForUser:(PFUser *)user;
- (void)setFollowStatus:(BOOL)following user:(PFUser *)user;



@end
