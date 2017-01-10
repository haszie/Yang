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
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];

}

#pragma mark EmptyDataSet

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"friends_menu_icon"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Add some friends!";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Swipe ← or hit the menu icon in the top left to open the menu. Navigate to the 'Friends' tab. If none of your friends are on Yang right now, invite them! Once you have some friends, hit the send icon to the top right to send some karma.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -self.tableView.tableHeaderView.frame.size.height/2.0f;
}

#pragma mark menu button

-(void) menuButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void) sendButtonPress {
    SendKarmaVC *vc = [[SendKarmaVC alloc] init];
    SendKarmaNav *nav = [[SendKarmaNav alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
}

@end

@implementation SendKarmaNav

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
