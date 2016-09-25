//
//  PostCell.m
//  Yang
//
//  Created by Biggie Smallz on 1/11/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell
@synthesize delegate;

- (void)awakeFromNib {
    [self setUp];
}

-(void) configureCell:(PostCell *) cell forObject:(PFObject *) object withDelegate:(id<PostCellDelegate, ProPicDelegate>) theDelegate {
    [self configureCell:cell forObject:object withIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] withDelegate:theDelegate];
}

-(void) configureCell:(PostCell *) cell forObject:(PFObject *) object withIndexPath:(NSIndexPath *) indexPath withDelegate:(id<PostCellDelegate, ProPicDelegate>) theDelegate {
    
    PFUser *theSender = [object objectForKey:kPostSenderKey];
    PFUser *theReceiver = [object objectForKey:kPostReceiverKey];
    
    if (cell.sender != nil && cell.receiver != nil) {
        [cell.sender setTheUser:theSender];
        [cell.receiver setTheUser:theReceiver];

        NSString *givr_name = theSender[@"first"];
        NSString *takr_name = theReceiver[@"first"];
        
        cell.sentence.text = [[NSString alloc] initWithFormat:@"%@ → %@", givr_name, takr_name];
    }
    
    int amt = [[object objectForKey:@"amt"] intValue];
    
    NSDate * date = object.createdAt;
    cell.dateLabel.text = [NSString stringWithFormat:@"%@ AGO", [date.shortTimeAgoSinceNow uppercaseString]];

    cell.words.text = [object objectForKey:@"text"];
    cell.karma.text = [NSString stringWithFormat:@"%d KARMA", amt];

    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
//    CGFloat maxLabelWidth = cell.words.frame.size.width;
//    CGSize neededSize = [cell.words sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
    
//    cell.landscape_photo.hidden = YES;
//    cell.portrait_photo.hidden = YES;
    
    if (object[@"photo"]) {
        [cell.mediaPreviewWidth setConstant:32.0f];
        [cell.mediaFromUserSpace setConstant:8.0f];

        PFFile *photo = [object objectForKey:@"photo"];
        [cell.mediaPreview sd_setImageWithURL:[NSURL URLWithString:photo.url]];

//        if ([object[@"isPortrait"] boolValue] == YES) {
//            cell.portrait_photo.hidden = NO;
//            [cell.portrait_photo sd_setImageWithURL:[NSURL URLWithString:photo.url]];
//        } else {
//            cell.landscape_photo.hidden = NO;
//            [cell.landscape_photo sd_setImageWithURL:[NSURL URLWithString:photo.url]];
//        }
    } else {
        [cell.mediaPreviewWidth setConstant:0.0f];
        [cell.mediaFromUserSpace setConstant:0.0f];
    }

    cell.sender.delegate = theDelegate;
    cell.receiver.delegate = theDelegate;
    
    [theSender fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        [cell.sender setTheUser:theSender];
        [cell.sender setNeedsLayout];
    }];
    
    [theReceiver fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        [cell.receiver setTheUser:theReceiver];
        [cell.receiver setNeedsLayout];
    }];
    
    //cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = theDelegate;
    cell.post = object;
    cell.tag = indexPath.row;

    cell.mediaPreview.layer.cornerRadius = 3.0f;
    cell.mediaPreview.contentMode = UIViewContentModeScaleAspectFill;
    [cell.mediaPreview.layer  setMasksToBounds:YES];
    
    NSDictionary *attributesForPost = [[YCash sharedCache] attributesForPost:object];
    
    if (attributesForPost) {
        [cell setUpvoteStatus:[[YCash sharedCache] currentUserGaveUpvoteForPost:object]];
        //[cell.upvotes setText:[[[YCash sharedCache] upvoteCountForPost:object] stringValue]];
        [cell.comment_btn setTitle:[self formatCommentsLabel:[[[YCash sharedCache] commentCountForPost:object] intValue]] forState:UIControlStateNormal];
        
        if (/*cell.upvotes.alpha < 1.0f ||*/ cell.comment_btn.alpha < 1.0f) {
            [UIView animateWithDuration:0.200f animations:^{
                //cell.upvotes.alpha = 1.0f;
                cell.comment_btn.alpha = 1.0f;
            }];
        }
    } else {
        //cell.upvotes.alpha = 0.0f;
        cell.comment_btn.alpha = 0.0f;
        
        @synchronized(theDelegate) {
            // check if we can update the cache
            NSNumber *outstandingSectionHeaderQueryStatus = [theDelegate.outstandingQueries objectForKey:@(indexPath.row)];
            if (!outstandingSectionHeaderQueryStatus) {
                PFQuery *query = [YUtil queryForActivitiesOnPost:object cachePolicy:kPFCachePolicyNetworkOnly];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    @synchronized(theDelegate) {
                        [theDelegate.outstandingQueries removeObjectForKey:@(indexPath.row)];
                        
                        if (error) {
                            return;
                        }
                        
                        NSMutableArray *upvoters = [NSMutableArray array];
                        NSMutableArray *commenters = [NSMutableArray array];
                        
                        BOOL currentUserGaveUpvote = NO;
                        
                        for (PFObject *activity in objects) {
                            if ([[activity objectForKey:kActivityTypeKey] isEqualToString:kActivityTypeUpvote] && [activity objectForKey:kActivityFromUserKey]) {
                                [upvoters addObject:[activity objectForKey:kActivityFromUserKey]];
                            } else if ([[activity objectForKey:kActivityTypeKey] isEqualToString:kActivityTypeComment] && [activity objectForKey:kActivityFromUserKey]) {
                                [commenters addObject:[activity objectForKey:kActivityFromUserKey]];
                            }
                            
                            if ([[[activity objectForKey:kActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                                if ([[activity objectForKey:kActivityTypeKey] isEqualToString:kActivityTypeUpvote]) {
                                    currentUserGaveUpvote = YES;
                                }
                            }
                        }
                        
                        [[YCash sharedCache] setAttributesForPost:object upvoters:upvoters commenters:commenters upvotedByCurrentUser:currentUserGaveUpvote];
                        
                        if (cell.tag != indexPath.row) {
                            return;
                        }
                        
                        [cell setUpvoteStatus:[[YCash sharedCache] currentUserGaveUpvoteForPost:object]];
                        //[cell.upvotes setText:[[[YCash sharedCache] upvoteCountForPost:object] stringValue]];
                        [cell.comment_btn setTitle:[self formatCommentsLabel:[[[YCash sharedCache] commentCountForPost:object] intValue]] forState:UIControlStateNormal];
                        
                        if (/*cell.upvotes.alpha < 1.0f ||*/ cell.comment_btn.alpha < 1.0f) {
                            [UIView animateWithDuration:0.200f animations:^{
                                //cell.upvotes.alpha = 1.0f;
                                cell.comment_btn.alpha = 1.0f;
                            }];
                        }
                    }
                }];
            }
        }
    }

}

-(NSString *) formatCommentsLabel:(int) numComments {
    if (numComments == 0) {
        return @"NO COMMENTS";
    } else if (numComments == 1) {
        return @"1 COMMENT";
    } else {
        return [NSString stringWithFormat:@"%d COMMENTS", numComments];
    }
}


-(void) setUp {
    
//    _bg.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    _bg.layer.shadowOffset = CGSizeMake(0, 1);
//    _bg.layer.shadowOpacity = 0.5;
//    _bg.layer.shadowRadius = 0.25;
//    _bg.clipsToBounds = NO;

//    _landscape_photo.contentMode = UIViewContentModeScaleAspectFill;
//    _portrait_photo.contentMode = UIViewContentModeScaleAspectFill;
//
//    [_up_btn setBackgroundImage:[UIImage imageNamed:@"up-arrow-blue"] forState:UIControlStateSelected];
//    [_up_btn setBackgroundImage:[UIImage imageNamed:@"up-arrow-gray"] forState:UIControlStateNormal];

//    _comment_btn.layer.borderWidth = 0.5;
//    _comment_btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _comment_btn.layer.cornerRadius = 2.5;
    
    self.contentView.userInteractionEnabled = NO;
}

-(void) setPost:(PFObject *)aPost {
    _post = aPost;
    //[_up_btn addTarget:self action:@selector(didTapUpvoteButton:) forControlEvents:UIControlEventTouchUpInside];
    [_comment_btn addTarget:self action:@selector(didTapCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    //[_ghost_btn addTarget:self action:@selector(ghost_hit) forControlEvents:UIControlEventTouchUpInside];
}

-(void) ghost_hit {
    //[_ghost_btn setUserInteractionEnabled:NO];
    //[self didTapUpvoteButton:self.up_btn];
    //[_ghost_btn setUserInteractionEnabled:YES];
}

- (void)setUpvoteStatus:(BOOL)upvote {
    //[self.up_btn setSelected:upvote];
}

-(void)didTapUpvoteButton:(UIButton *)button {
    if (delegate && [delegate respondsToSelector:@selector(didTapUpvoteButton:forPostCell:forPost:)]) {
        [delegate didTapUpvoteButton:button forPostCell:self forPost:_post];
    }
}

-(void) didTapCommentButton:(UIButton *)button {
    if (delegate && [delegate respondsToSelector:@selector(didTapCommentButton:forPostCell:forPost:)]) {
        [delegate didTapCommentButton:button forPostCell:self forPost:_post];
    }
}


@end