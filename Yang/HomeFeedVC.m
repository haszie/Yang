//
//  HomeFeedVC.m
//  Yang
//
//  Created by Biggie Smallz on 1/11/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "HomeFeedVC.h"
#import "SendKarmaVC.h"

@implementation HomeFeedVC
@synthesize scrollToTop;
    
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        scrollToTop = NO;
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];    
    
    UIView * frame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIImage *logo = [UIImage imageNamed:@"logo-2"];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:logo];
    logoView.frame = CGRectMake(75, 0, 150, 44);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    [frame addSubview:logoView];
    
    self.navigationItem.titleView = logoView;
    
    UIImage *image = [UIImage imageNamed:@"send"];
    CGRect buttonFrame = CGRectMake(0, 0, 22, 22);
    
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:self action:@selector(sendButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = item;
    
    UIImage *menu_img = [UIImage imageNamed:@"menu-alt"];
    CGRect menu_frame = CGRectMake(0, 0, 22, 22);
    
    UIButton *menu_btn = [[UIButton alloc] initWithFrame:menu_frame];
    [menu_btn addTarget:self action:@selector(menuButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [menu_btn setImage:menu_img forState:UIControlStateNormal];
    
    UIBarButtonItem *menu_itm= [[UIBarButtonItem alloc] initWithCustomView:menu_btn];
    
    self.navigationItem.leftBarButtonItem= menu_itm;
}

-(void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
//    if (self.objects.count == 0) {
//        UILabel * bg = [[UILabel alloc] initWithFrame:CGRectMake(64.0f, self.view.frame.size.height / 2.0f - 96.0f, self.view.frame.size.width - 128.0f, 120.0f)];
//        [bg setFont:[UIFont fontWithName:@"OpenSans-Light" size:18.0f]];
//        bg.text = @"← Add friends and start Yangin' out";
//        bg.numberOfLines = 0;
//        [bg sizeToFit];
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self.view addSubview:bg];
//    }
}

-(void) menuButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void) sendButtonPress {
    SendKarmaVC *vc = [[SendKarmaVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
