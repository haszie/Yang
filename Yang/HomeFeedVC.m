//
//  HomeFeedVC.m
//  Yang
//
//  Created by Biggie Smallz on 1/11/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "HomeFeedVC.h"
#import "SendKarmaVC.h"
#import "MenuVC.h"

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
    NSString *text = @"No posts to show";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"This could be because you are not following anyone or because no one has posted yet. Start following some friends and then send them some karma.";
    
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

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 22.0f;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:[UIFont boldSystemFontOfSize:18.0f] forKey:NSFontAttributeName];
    [attributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:@"Add Friends Now" attributes:attributes];
}

-(UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    UIEdgeInsets capInsets = UIEdgeInsetsMake(25.0, 25.0, 25.0, 25.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsMake(0.0, 10, 0.0, 10);

    return [[[UIImage imageNamed:@"button_background"] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];

}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        UINavigationController *nav = (UINavigationController *) [self.mm_drawerController centerViewController];

        [nav setViewControllers:@[[MenuVC fwends]] animated:NO];
    }];
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
