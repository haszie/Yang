//
//  PostCell.h
//  Yang
//
//  Created by Biggie Smallz on 1/11/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "DateTools.h"
#import "YUtil.h"
#import "ProPicIV.h"

@protocol PostCellDelegate;

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet ProPicIV *sender;
@property (weak, nonatomic) IBOutlet ProPicIV *receiver;
@property (weak, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *toUserLbl;

@property (retain, nonatomic) IBOutlet UILabel *upvotes;
@property (retain, nonatomic) IBOutlet UILabel *fromUserLbl;
@property (retain, nonatomic) IBOutlet UILabel *words;
@property (weak, nonatomic) IBOutlet UIButton *ghost_btn;
@property (weak, nonatomic) IBOutlet UIButton *up_btn;

@property (weak, nonatomic) IBOutlet UIImageView *mediaPreview;

@property (nonatomic, weak) id <PostCellDelegate> delegate;
@property (nonatomic, strong) PFObject *post;

@property (nonatomic) UIButton * fromUserButton;
@property (nonatomic) UIButton * toUserButton;

- (void)setUpvoteStatus:(BOOL)upvote;

-(void) configureCell:(PostCell *) cell forObject:(PFObject *) object withDelegate:(id<PostCellDelegate, ProPicDelegate>) theDelegate;
-(void) configureCell:(PostCell *) cell forObject:(PFObject *) object withIndexPath:(NSIndexPath *) indexPath withDelegate:(id<PostCellDelegate, ProPicDelegate>) theDelegate;

@end

@protocol PostCellDelegate <NSObject>

-(void) didTapUpvoteButton:(UIButton *)button forPostCell:(PostCell *)postCell  forPost:(PFObject *)post;
-(void) didTapUsername: (PFUser *) user;

@property (nonatomic, strong) NSMutableDictionary *outstandingQueries;

@end
