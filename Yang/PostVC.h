//
//  PostVC.h
//  Yang
//
//  Created by Biggie Smallz on 2/9/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Bolts/Bolts.h>
#import <ParseUI/ParseUI.h>
#import "PostCell.h"
#import "DateTools.h"
#import "FriendCell.h"
#import "MBProgressHUD.h"
#import "YUtil.h"
#import "YangRefresh.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface PostVC : UITableViewController <PostCellDelegate, ProPicDelegate, UITextFieldDelegate>

- (id)initWithPFObject: (PFObject *) obj withHeight: (CGFloat) height ;

@property (nullable, nonatomic, strong) UITextField *comment_field;

@property (strong, nonatomic, nullable) YangRefresh *quickRefresh;

@property BOOL addMenuButton;

@property (nullable, nonatomic, copy, readonly) NSArray<__kindof PFObject *> *objects;
- (nullable PFObject *)objectAtIndexPath:(nullable NSIndexPath *)indexPath;
- (nullable BFTask<NSArray<__kindof PFObject *> *> *)loadObjects;
- (nullable BFTask<NSArray<__kindof PFObject *> *> *)loadObjects:(NSInteger)page clear:(BOOL)clear;
- (nullable PFQuery *)queryForTable;

@end
