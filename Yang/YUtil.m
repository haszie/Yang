//
//  YUtil.m
//  Yang
//
//  Created by Biggie Smallz on 2/10/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "YUtil.h"

@implementation YUtil

static MMDrawerController *drawer;

+ (void) setTheDrawer:(MMDrawerController *) theDrawer {
    drawer = theDrawer;
}

+ (MMDrawerController *) getTheDrawer {
    return drawer;
}

+(UIColor *)theColor {
    return [UIColor colorWithRed:0.0/255.0f green:51.0/255.0f blue:102.0/255.0f alpha:1.0f];
}

+ (void)upvotePostInBackground:(id)post block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    PFQuery *queryExistingVotes = [PFQuery queryWithClassName:kActivityClassKey];
    [queryExistingVotes whereKey:kActivityPostKey equalTo:post];
    [queryExistingVotes whereKey:kActivityTypeKey equalTo:kActivityTypeUpvote];
    [queryExistingVotes whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingVotes setCachePolicy:kPFCachePolicyNetworkOnly];
    
    [queryExistingVotes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity delete];
            }
        }
        
        PFObject *upvoteActivity = [PFObject objectWithClassName:kActivityClassKey];
        [upvoteActivity setObject:kActivityTypeUpvote forKey:kActivityTypeKey];
        [upvoteActivity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
        [upvoteActivity setObject:post[kPostReceiverKey] forKey:kActivityToUserKey];
        [upvoteActivity setObject:post forKey:kActivityPostKey];
        
        PFACL *upvoteACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [upvoteACL setPublicReadAccess:YES];
        [upvoteACL setWriteAccess:YES forUser:[post objectForKey:kPostSenderKey]];
        upvoteActivity.ACL = upvoteACL;
        
        [upvoteActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded,error);
            }
            
            // refresh cache
            PFQuery *query = [YUtil queryForActivitiesOnPost:post cachePolicy:kPFCachePolicyNetworkOnly];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    NSMutableArray *likers = [NSMutableArray array];
                    NSMutableArray *commenters = [NSMutableArray array];
                    
                    BOOL isLikedByCurrentUser = NO;
                    
                    for (PFObject *activity in objects) {
                        if ([[activity objectForKey:kActivityTypeKey] isEqualToString:kActivityTypeUpvote] && [activity objectForKey:kActivityFromUserKey]) {
                            [likers addObject:[activity objectForKey:kActivityFromUserKey]];
                        } else if ([[activity objectForKey:kActivityTypeKey] isEqualToString:kActivityTypeComment] && [activity objectForKey:kActivityFromUserKey]) {
                            [commenters addObject:[activity objectForKey:kActivityFromUserKey]];
                        }
                        
                        if ([[[activity objectForKey:kActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                            if ([[activity objectForKey:kActivityTypeKey] isEqualToString:kActivityTypeUpvote]) {
                                isLikedByCurrentUser = YES;
                            }
                        }
                    }
                    
                    [[YCash sharedCache] setAttributesForPost:post upvoters:likers commenters:commenters upvotedByCurrentUser:isLikedByCurrentUser];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:YUtilUserUpvotePostCallbackFinishedNotification object:post userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:succeeded] forKey:YPostVCUserUpvotePostNotification]];
            }];
            
        }];
    }];
}

//+ (void)unUpvotePostInBackground:(id)post block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
//    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kActivityClassKey];
//    [queryExistingLikes whereKey:kActivityPostKey equalTo:post];
//    [queryExistingLikes whereKey:kActivityTypeKey equalTo:kActivityTypeUpvote];
//    [queryExistingLikes whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
//    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
//    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
//        if (!error) {
//            PFObject *activity = [activities firstObject];
//            [activity deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//                if (completionBlock) {
//                    completionBlock(YES,nil);
//                }
//                
//                // refresh cache
//                PFQuery *query = [YUtil queryForActivitiesOnPost:post cachePolicy:kPFCachePolicyNetworkOnly];
//                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                    if (!error) {
//                        
//                        NSMutableArray *likers = [NSMutableArray array];
//                        NSMutableArray *commenters = [NSMutableArray array];
//                        
//                        BOOL isLikedByCurrentUser = NO;
//                        
//                        for (PFObject *activity in objects) {
//                            if ([[activity objectForKey:kActivityTypeKey] isEqualToString:kActivityTypeUpvote]) {
//                                [likers addObject:[activity objectForKey:kActivityFromUserKey]];
//                            } else if ([[activity objectForKey:kActivityTypeKey] isEqualToString:kActivityTypeComment]) {
//                                [commenters addObject:[activity objectForKey:kActivityFromUserKey]];
//                            }
//                            
//                            if ([[[activity objectForKey:kActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
//                                if ([[activity objectForKey:kActivityTypeKey] isEqualToString:kActivityTypeUpvote]) {
//                                    isLikedByCurrentUser = YES;
//                                }
//                            }
//                        }
//                        
//                        [[YCash sharedCache] setAttributesForPost:post upvoters:likers commenters:commenters upvotedByCurrentUser:isLikedByCurrentUser];
//                    }
//                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:YUtilUserUpvotePostCallbackFinishedNotification object:post userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:YPostVCUserUpvotePostNotification]];
//                    
//                }];
//            }];
//            
//        } else {
//            if (completionBlock) {
//                completionBlock(NO,error);
//            }
//        }
//    }];
//}

#pragma mark - User counts

+ (PFQuery *)upvoteCountForUser:(PFUser *)user {
    
    PFQuery * query = [PFQuery queryWithClassName:kActivityClassKey];
    [query whereKey:kActivityReceiverKey equalTo:user];
    [query whereKey:kActivityTypeKey equalTo:kActivityTypeUpvote];
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    
    return query;
}

+ (PFQuery *)sendCountForUser:(PFUser *)user {
    PFQuery * query = [PFQuery queryWithClassName:kPostClassKey];
    [query whereKey:kPostSenderKey equalTo:user];
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];

    return query;
}

+ (PFQuery *)receiveCountFor:(PFUser *)user {
    PFQuery * query = [PFQuery queryWithClassName:kPostClassKey];
    [query whereKey:kPostReceiverKey equalTo:user];
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    
    return query;
}

+ (BOOL)userHasProfilePicture:(PFUser *)user {
    PFFile *propic = [user objectForKey:kUserProfilePicture];
    
    return (propic != nil);
}

+ (UIImage *)defaultProfilePicture {
    return [UIImage imageNamed:@"user_palceholder"];
}

#pragma mark Display Name

+ (NSString *)firstNameForDisplayName:(NSString *)displayName {
    if (!displayName || displayName.length == 0) {
        return @"Someone";
    }
    
    NSArray *displayNameComponents = [displayName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *firstName = [displayNameComponents objectAtIndex:0];
    if (firstName.length > 100) {
        // truncate to 100 so that it fits in a Push payload
        firstName = [firstName substringToIndex:100];
    }
    return firstName;
}


#pragma mark User Following

+ (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        return;
    }
    
    PFObject *followActivity = [PFObject objectWithClassName:kActivityClassKey];
    [followActivity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
    [followActivity setObject:user forKey:kActivityToUserKey];
    [followActivity setObject:kActivityTypeFollow forKey:kActivityTypeKey];
    
    PFACL *followACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [followACL setPublicReadAccess:YES];
    followActivity.ACL = followACL;
    
    [followActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completionBlock) {
            completionBlock(succeeded, error);
        }
    }];
    [[YCash sharedCache] setFollowStatus:YES user:user];
}

+ (void)followUserEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        return;
    }
    
    PFObject *followActivity = [PFObject objectWithClassName:kActivityClassKey];
    [followActivity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
    [followActivity setObject:user forKey:kActivityToUserKey];
    [followActivity setObject:kActivityTypeFollow forKey:kActivityTypeKey];
    
    PFACL *followACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [followACL setPublicReadAccess:YES];
    followActivity.ACL = followACL;
    
    [followActivity saveEventually:completionBlock];
    [[YCash sharedCache] setFollowStatus:YES user:user];
}

+ (void)followUsersEventually:(NSArray *)users block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    for (PFUser *user in users) {
        [YUtil followUserEventually:user block:completionBlock];
        [[YCash sharedCache] setFollowStatus:YES user:user];
    }
}

+ (void)unfollowUserEventually:(PFUser *)user {
    PFQuery *query = [PFQuery queryWithClassName:kActivityClassKey];
    [query whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kActivityToUserKey equalTo:user];
    [query whereKey:kActivityTypeKey equalTo:kActivityTypeFollow];
    [query findObjectsInBackgroundWithBlock:^(NSArray *followActivities, NSError *error) {
        // While normally there should only be one follow activity returned, we can't guarantee that.
        
        if (!error) {
            for (PFObject *followActivity in followActivities) {
                [followActivity deleteEventually];
            }
        }
    }];
    [[YCash sharedCache] setFollowStatus:NO user:user];
}

+ (void)unfollowUsersEventually:(NSArray *)users {
    PFQuery *query = [PFQuery queryWithClassName:kActivityClassKey];
    [query whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kActivityToUserKey containedIn:users];
    [query whereKey:kActivityTypeKey equalTo:kActivityTypeFollow];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        for (PFObject *activity in activities) {
            [activity deleteEventually];
        }
    }];
    for (PFUser *user in users) {
        [[YCash sharedCache] setFollowStatus:NO user:user];
    }
}

+ (BOOL)currentUserDoesFollowUser:(PFUser *) user{
    BOOL check = [[YCash sharedCache] followStatusForUser:user];
    
    if (!check) {
        PFQuery *query = [PFQuery queryWithClassName:kActivityClassKey];
        [query whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
        [query whereKey:kActivityToUserKey equalTo:user];
        [query whereKey:kActivityTypeKey equalTo:kActivityTypeFollow];
        [query setCachePolicy:kPFCachePolicyNetworkOnly];
        
        PFObject *follow = [query getFirstObject];
        
        if (follow) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
}

#pragma mark Activities

+ (PFQuery *)queryForActivitiesOnPost:(PFObject *)post cachePolicy:(PFCachePolicy)cachePolicy {
    PFQuery *queryLikes = [PFQuery queryWithClassName:kActivityClassKey];
    [queryLikes whereKey:kActivityPostKey equalTo:post];
    [queryLikes whereKey:kActivityTypeKey equalTo:kActivityTypeUpvote];
    
    PFQuery *queryComments = [PFQuery queryWithClassName:kActivityClassKey];
    [queryComments whereKey:kActivityPostKey equalTo:post];
    [queryComments whereKey:kActivityTypeKey equalTo:kActivityTypeComment];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryLikes,queryComments,nil]];
    [query setCachePolicy:cachePolicy];
    [query includeKey:kActivityFromUserKey];
    [query includeKey:kActivityPostKey];
    
    return query;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(CGFloat) calcHeight:(PFObject *) post withFrame:(CGRect) frame {
    CGFloat height = 0;
    
    // headline
    height += 12 + 32 + 12;
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = [post objectForKey:@"text"];
    lbl.numberOfLines = 6;
    [lbl setFont:[UIFont fontWithName:@"OpenSans" size:15.0f]];
    
    CGFloat maxLabelWidth = frame.size.width - 16;

    CGSize neededSize = [lbl sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];

    // words
    height += neededSize.height;
    
    // pad
    height += 6;
 
    if (post[@"photo"]) {
        height += 44;
    } else {
        height += 22;
    }
    
    //pad
    height += 12;
    
    //NSLog([NSString stringWithFormat:@"%@: %f\n", lbl.text, height]);
    
    return height;
}


@end
