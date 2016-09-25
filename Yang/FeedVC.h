//
//  FeedVC.h
//  Yang
//
//  Created by Biggie Smallz on 2/12/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Bolts/Bolts.h>
#import <ParseUI/ParseUI.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImagePrefetcher.h>
#import <MMDrawerController/MMDrawerController.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>

#import "PostCell.h"
#import "YangRefresh.h"

@interface FeedVC : PFQueryTableViewController <PostCellDelegate, ProPicDelegate>

@property (strong, nonatomic) YangRefresh *quickRefresh;
@property (nonatomic) BOOL quickEnabled;
@property BOOL scrollToTop;
@property (nonatomic) UIImageView *mediaScreen;

-(void)tableViewWasPulledToRefresh;

@end
