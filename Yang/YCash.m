//
//  YCash.m
//  
//
//  Created by Biggie Smallz on 2/10/16.
//
//

#import "YCash.h"

@interface YCash()

@property (nonatomic, strong) NSCache *cache;
- (void)setAttributes:(NSDictionary *)attributes forPost:(PFObject *)post;

@end

@implementation YCash
@synthesize cache;

#pragma mark - Initialization

+ (id)sharedCache {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        self.cache = [[NSCache alloc] init];
    }
    return self;
}

#pragma mark - PAPCache

- (void)clear {
    [self.cache removeAllObjects];
}

- (void)setAttributesForPost:(PFObject *)post upvoters:(NSArray *)upvoters commenters:(NSArray *)commenters upvotedByCurrentUser:(BOOL)upvotedByCurrentUser
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:upvotedByCurrentUser],kPostCurrentUserGaveUpvoteKey,
                                @([upvoters count]),kPostUpvoteCountKey,
                                upvoters,kPostUpvotersKey,
                                @([commenters count]),kPostCommentCountKey,
                                commenters,kPostCommentersKey,
                                nil];
    [self setAttributes:attributes forPost:post];
}

- (NSDictionary *)attributesForPost:(PFObject *)post {
    NSString *key = [self keyForPost:post];
    return [self.cache objectForKey:key];
}

- (NSNumber *)upvoteCountForPost:(PFObject *)post {
    NSDictionary *attributes = [self attributesForPost:post];
    if (attributes) {
        return [attributes objectForKey:kPostUpvoteCountKey];
    }
    
    return [NSNumber numberWithInt:0];
}

- (NSNumber *)commentCountForPost:(PFObject *)post {
    NSDictionary *attributes = [self attributesForPost:post];
    if (attributes) {
        return [attributes objectForKey:kPostCommentCountKey];
    }
    
    return [NSNumber numberWithInt:0];
}

- (NSArray *)upvotersForPost:(PFObject *)post {
    NSDictionary *attributes = [self attributesForPost:post];
    if (attributes) {
        return [attributes objectForKey:kPostUpvotersKey];
    }
    
    return [NSArray array];
}

- (NSArray *)commentersForPost:(PFObject *)post {
    NSDictionary *attributes = [self attributesForPost:post];
    if (attributes) {
        return [attributes objectForKey:kPostCommentersKey];
    }
    
    return [NSArray array];
}

- (void)setCurrentUserGaveUpvoteForPost:(PFObject *)post upvoted:(BOOL)upvote {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPost:post]];
    [attributes setObject:[NSNumber numberWithBool:upvote] forKey:kPostCurrentUserGaveUpvoteKey];
    [self setAttributes:attributes forPost:post];
}

- (BOOL)currentUserGaveUpvoteForPost:(PFObject *)post {
    NSDictionary *attributes = [self attributesForPost:post];
    if (attributes) {
        return [[attributes objectForKey:kPostCurrentUserGaveUpvoteKey] boolValue];
    }
    
    return NO;
}

- (void)incrementUpvoterCountForPost:(PFObject *)post {
    NSNumber *likerCount = [NSNumber numberWithInt:[[self upvoteCountForPost:post] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPost:post]];
    [attributes setObject:likerCount forKey:kPostUpvoteCountKey];
    [self setAttributes:attributes forPost:post];
}

- (void)decrementUpvoterCountForPost:(PFObject *)post {
    NSNumber *likerCount = [NSNumber numberWithInt:[[self upvoteCountForPost:post] intValue] - 1];
    if ([likerCount intValue] < 0) {
        return;
    }
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPost:post]];
    [attributes setObject:likerCount forKey:kPostUpvoteCountKey];
    [self setAttributes:attributes forPost:post];
}

- (void)incrementCommentCountForPost:(PFObject *)post {
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForPost:post] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPost:post]];
    [attributes setObject:commentCount forKey:kPostCommentCountKey];
    [self setAttributes:attributes forPost:post];
}

- (void)decrementCommentCountForPost:(PFObject *)post {
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForPost:post] intValue] - 1];
    if ([commentCount intValue] < 0) {
        return;
    }
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPost:post]];
    [attributes setObject:commentCount forKey:kPostCommentCountKey];
    [self setAttributes:attributes forPost:post];
}

- (void)setAttributesForUser:(PFUser *)user postCount:(NSNumber *)count followedByCurrentUser:(BOOL)following {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                count,[NSNumber numberWithBool:following],kUserIsFollowedByCurrentUser,
                                nil];
    [self setAttributes:attributes forUser:user];
}

- (NSDictionary *)attributesForUser:(PFUser *)user {
    NSString *key = [self keyForUser:user];
    return [self.cache objectForKey:key];
}

- (BOOL)followStatusForUser:(PFUser *)user {
    NSDictionary *attributes = [self attributesForUser:user];
    if (attributes) {
        NSNumber *followStatus = [attributes objectForKey:kUserIsFollowedByCurrentUser];
        if (followStatus) {
            return [followStatus boolValue];
        }
    }
    
    return NO;
}

- (void)setFollowStatus:(BOOL)following user:(PFUser *)user {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForUser:user]];
    [attributes setObject:[NSNumber numberWithBool:following] forKey:kUserIsFollowedByCurrentUser];
    [self setAttributes:attributes forUser:user];
}

#pragma mark - ()

- (void)setAttributes:(NSDictionary *)attributes forPost:(PFObject *)post {
    NSString *key = [self keyForPost:post];
    [self.cache setObject:attributes forKey:key];
}

- (void)setAttributes:(NSDictionary *)attributes forUser:(PFUser *)user {
    NSString *key = [self keyForUser:user];
    [self.cache setObject:attributes forKey:key];
}

- (NSString *)keyForPost:(PFObject *)post {
    return [NSString stringWithFormat:@"post_%@", [post objectId]];
}

- (NSString *)keyForUser:(PFUser *)user {
    return [NSString stringWithFormat:@"user_%@", [user objectId]];
}

@end
