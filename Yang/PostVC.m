//
//  PostVC.m
//  Yang
//
//  Created by Biggie Smallz on 2/9/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "PostVC.h"
#import "ProPicIV.h"
#import "UserProfileVC.h"

@interface PostVC () {
    PFObject *post;
    CGFloat cell_height;
    NSMutableArray<PFObject *> *_mutableObjects;
    BOOL userDidTapCommentButton;
    BOOL scrollToLast;
}

@end

@implementation PostVC
@synthesize outstandingQueries;

- (id)initWithPFObject: (PFObject *) obj withHeight: (CGFloat) height userDidTapCommentButton:(BOOL) didTap  {
    self = [super init];
    if(self) {
        post = obj;
        cell_height = height;
        _mutableObjects = [NSMutableArray array];
        userDidTapCommentButton = didTap;
        outstandingQueries = [NSMutableDictionary dictionary];
        scrollToLast = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 8, 0, 8);
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"CommentCell"];

    [post fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            
            [post[@"giver"] fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                if (!error) {
                    [post[@"taker"] fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                        [self loadObjects];
                        
                        PostCell *cell = (PostCell *) [[[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil] firstObject];
                        [cell setFrame:CGRectMake(0, 0, self.view.frame.size.width, cell_height)];
                        
                        [cell configureCell:cell forObject:post withDelegate:self];
                        cell.bg.layer.shadowColor = [UIColor clearColor].CGColor;
                        
                        self.tableView.tableHeaderView = cell;
                    }];
                }
            }];
        }
    }];
    
    NewCommentView *ncv = [[NewCommentView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    
    PFFile *propic = [[PFUser currentUser] objectForKey:kUserProfilePicture];
    [ncv set_user_pic:propic.url];
    
    if (self.addMenuButton) {
        UIImage *menu_img = [UIImage imageNamed:@"menu-alt"];
        CGRect menu_frame = CGRectMake(0, 0, 22, 22);
        
        UIButton *menu_btn = [[UIButton alloc] initWithFrame:menu_frame];
        [menu_btn addTarget:self action:@selector(menuButtonPress) forControlEvents:UIControlEventTouchUpInside];
        [menu_btn setImage:menu_img forState:UIControlStateNormal];
        
        UIBarButtonItem *menu_itm= [[UIBarButtonItem alloc] initWithCustomView:menu_btn];
        
        self.navigationItem.leftBarButtonItem = menu_itm;
    }
    
    self.tableView.tableFooterView = ncv;
    _comment_field = ncv.commentField;
    _comment_field.delegate = self;

    self.quickRefresh = [[YangRefresh alloc] initWithType:JHRefreshControlTypeSlideDown];
    __weak id weakSelf = self;
    [self.quickRefresh addToScrollView:self.tableView withRefreshBlock:^{
        [weakSelf tableViewWasPulledToRefresh];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChangedPostAttr:) name:YPostVCUserUpvotePostNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChangedPostAttr:) name:YUtilUserUpvotePostCallbackFinishedNotification object:nil];

}

-(void) menuButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (userDidTapCommentButton) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_comment_field becomeFirstResponder];
        });
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YPostVCUserUpvotePostNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YUtilUserUpvotePostCallbackFinishedNotification object:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_comment_field resignFirstResponder];
}

#pragma mark TableViewStuff

- (UITableViewCell *)tableView:(UITableView *)otherTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:otherTableView cellForRowAtIndexPath:indexPath object:[self objectAtIndexPath:indexPath]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.objects count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self objectAtIndexPath:indexPath];
    
    if (object) {
        NSString *commentString = [object objectForKey:kActivityContentKey];
        
        PFUser *commentAuthor = (PFUser *)[object objectForKey:kActivityFromUserKey];
        
        NSString *nameString = @"";
        if (commentAuthor) {
            nameString = [commentAuthor objectForKey:kUserUsername];
        }
        return [CommentCell heightForCellWithName:nameString contentString:commentString cellInsetWidth:0.0f];
    }
    return 60.0f;
}

#pragma mark - PostCellDelegate

-(void)didTapUpvoteButton:(UIButton *)button forPostCell:(PostCell *)postCell  forPost:(PFObject *)thePost {
    
    [button setUserInteractionEnabled:NO];
    
    BOOL upvoted = !button.selected;
    [postCell setUpvoteStatus:upvoted];
    
    //NSString *originalButtonTitle = [self normalize:button.titleLabel.text];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSNumber *upvotes = [numberFormatter numberFromString:[self normalize:button.titleLabel.text]];
    if (upvoted) {
        upvotes = [NSNumber numberWithInt:[upvotes intValue] + 1];
        [[YCash sharedCache] incrementUpvoterCountForPost:thePost];
    } else {
        if ([upvotes intValue] > 0) {
            upvotes = [NSNumber numberWithInt:[upvotes intValue] - 1];
        }
        [[YCash sharedCache] decrementUpvoterCountForPost:thePost];
    }
    
    [[YCash sharedCache] setCurrentUserGaveUpvoteForPost:thePost upvoted:upvoted];
        
    if (upvoted) {
        [YUtil upvotePostInBackground:thePost block:^(BOOL succeeded, NSError *error) {
            [button setUserInteractionEnabled:YES];
        }];
    }
//    } else {
//        [YUtil unUpvotePostInBackground:thePost block:^(BOOL succeeded, NSError *error) {
//            [button setUserInteractionEnabled:YES];
//        }];
//    }
}

-(void)didTapCommentButton:(UIButton *)button forPostCell:(PostCell *)postCell  forPost:(PFObject *)thePost {
    [_comment_field becomeFirstResponder];
}

-(NSString*) normalize: (NSString *) number{
    NSMutableCharacterSet *nonNumberCharacterSet = [NSMutableCharacterSet decimalDigitCharacterSet];
    [nonNumberCharacterSet invert];
    
    return [[number componentsSeparatedByCharactersInSet:nonNumberCharacterSet] componentsJoinedByString:@""];
}

#pragma mark - PFQueryStuff

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:kActivityClassKey];
    [query whereKey:kActivityPostKey equalTo:post];
    [query includeKey:kActivityFromUserKey];
    [query whereKey:kActivityTypeKey equalTo:kActivityTypeComment];
    [query orderByAscending:@"createdAt"];
    
    [query setCachePolicy:kPFCachePolicyNetworkOnly];

    if (self.objects.count == 0) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    
    return query;
}

-(void)objectsDidLoad:(NSError *)error {
    [self.quickRefresh endRefreshing];
}

-(void)tableViewWasPulledToRefresh {
    [self loadObjects];
}

- (BFTask<NSArray<__kindof PFObject *> *> *)loadObjects {
    return [self loadObjects:0 clear:YES];
}

- (BFTask<NSArray<__kindof PFObject *> *> *)loadObjects:(NSInteger)page clear:(BOOL)clear {
    
    PFQuery *query = [self queryForTable];
    
    BFTaskCompletionSource<NSArray<__kindof PFObject *> *> *source = [BFTaskCompletionSource taskCompletionSource];
    [query findObjectsInBackgroundWithBlock:^(NSArray *foundObjects, NSError *error) {
        if (error) {
            NSLog(@"Error loading objects\n");
            NSLog(@"%@", [error localizedDescription]);
        } else {
            
            if (clear) {
                [_mutableObjects removeAllObjects];
            }
            
            [_mutableObjects addObjectsFromArray:foundObjects];
            [self.tableView reloadData];
            
            if (scrollToLast && self.objects.count != 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    scrollToLast = NO;
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.objects.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                });
            }
        }
        
        [self objectsDidLoad:error];
        
        if (error) {
            [source trySetError:error];
        } else {
            [source trySetResult:foundObjects];
        }
    }];
    
    return source.task;
}

- (void)tableView:(UITableView *)tableView
    configureCell:(CommentCell *)cell
      atIndexPath:(NSIndexPath *)indexPath
           object:(PFObject *)object {

    [cell setUser:[object objectForKey:kActivityFromUserKey]];
    [cell setContentText:[object objectForKey:kActivityContentKey]];
    [cell setDate:[object createdAt]];
    cell.avatar.delegate = self;
}

- (CommentCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
                   object:(PFObject *)object {
    
    CommentCell *cell = (CommentCell *) [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
    }
    
    [self tableView:tableView configureCell:cell atIndexPath:indexPath object:object];

    return cell;
}

- (NSArray<__kindof PFObject *> *)objects {
    return _mutableObjects;
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {

    return self.objects[indexPath.row];
}

#pragma mark - ProPicDelegate

-(void)didTapUserPic:(ProPicIV *)thePic {
    UserProfileVC *upvc = [[UserProfileVC alloc] initWithUser:thePic.theUser];
    [self.navigationController pushViewController:upvc animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    userDidTapCommentButton = NO;
    NSString *trimmedComment = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedComment.length != 0 && [post objectForKey:kPostSenderKey]) {
        PFObject *comment = [PFObject objectWithClassName:kActivityClassKey];
        [comment setObject:trimmedComment forKey:kActivityContentKey]; // Set comment text
        [comment setObject:[post objectForKey:kPostSenderKey] forKey:kActivityToUserKey]; // Set toUser
        [comment setObject:[PFUser currentUser] forKey:kActivityFromUserKey]; // Set fromUser
        [comment setObject:[post objectForKey:kPostSenderKey] forKey:kActivitySenderKey];
        [comment setObject:[post objectForKey:kPostReceiverKey] forKey:kActivityReceiverKey];
        [comment setObject:kActivityTypeComment forKey:kActivityTypeKey];
        [comment setObject:post forKey:kActivityPostKey];
        
        PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [ACL setPublicReadAccess:YES];
        [ACL setWriteAccess:YES forUser:[post objectForKey:kPostSenderKey]];
        comment.ACL = ACL;
        
        [[YCash sharedCache] incrementCommentCountForPost:post];
        
        // Show HUD view
        [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
        
        // If more than 5 seconds pass since we post a comment, stop waiting for the server to respond
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(handleCommentTimeout:) userInfo:@{@"comment": comment} repeats:NO];
        
        [comment saveEventually:^(BOOL succeeded, NSError *error) {
            [timer invalidate];
            
            if (error && error.code == kPFErrorObjectNotFound) {
                [[YCash sharedCache] decrementCommentCountForPost:post];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not post comment", nil) message:NSLocalizedString(@"This photo is no longer available", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
            scrollToLast = YES;
            [self loadObjects];
        }];
    }
    
    [textField setText:@""];
    return [textField resignFirstResponder];
}

#pragma mark - NSNotifications

- (void)userChangedPostAttr:(NSNotification *)note {
    PostCell *heada = (PostCell *) self.tableView.tableHeaderView;
    //heada.upvotes.text = [[[YCash sharedCache] upvoteCountForPost:heada.post] stringValue];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        if ((self.view.frame.size.height - self.tableView.contentSize.height) < kbSize.height) {
            CGPoint scrollPoint = CGPointMake(0.0, self.tableView.contentOffset.y + 20);
            [self.tableView setContentOffset:scrollPoint animated:YES];
        }
    });
}


- (void)handleCommentTimeout:(NSTimer *)aTimer {
    [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New Comment", nil) message:NSLocalizedString(@"Your comment will be posted next time there is an Internet connection.", nil)  delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Dismiss", nil), nil];
    [alert show];
}

@end
