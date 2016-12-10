//
//  SendKarmaVC.m
//  Yang
//
//  Created by Biggie Smallz on 1/15/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "SendKarmaVC.h"

@interface SendKarmaVC () {
    NSMutableArray<PFObject *> *_mutableObjects;
    NSMutableArray<PFObject *> *_filteredObjects;

    BOOL success;
}

@end

@implementation SendKarmaVC


-(id) initWithUsername:(PFUser *) user {
    self = [super init];
    if (self) {
        self.sendToUser = user;
        self.usernameToSend = user.username;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    _mutableObjects = [NSMutableArray array];
    _filteredObjects = [NSMutableArray array];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor lightTextColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0/255.0f green:51.0/255.0f blue:102.0/255.0f alpha:1.0f]];
    
    UIView * frame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIImage *logo = [UIImage imageNamed:@"send-karma"];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:logo];
    logoView.frame = CGRectMake(75, 0, 150, 44);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    
    [frame addSubview:logoView];
    
    self.navigationItem.titleView = logoView;
    
    UIImage *cancel = [UIImage imageNamed:@"cancel"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.bounds = CGRectMake(0, 0, 22, 22);
    [btn setImage:cancel forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelBtnHit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancel_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = cancel_btn;

//    UIImage *check = [UIImage imageNamed:@"check"];
    UIButton *check_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    check_btn.bounds = CGRectMake(0, 0, 22, 22);
//    [check_btn setImage:check forState:UIControlStateNormal];
    UIBarButtonItem *check_bar_btn = [[UIBarButtonItem alloc] initWithCustomView:check_btn];
    self.navigationItem.rightBarButtonItem = check_bar_btn;

    _camera_btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_send_btn addTarget:self action:@selector(send_btn_hit) forControlEvents:UIControlEventTouchUpInside];
    [_camera_btn addTarget:self action:@selector(camera_btn_hit) forControlEvents:UIControlEventTouchUpInside];
    
    _recv_img.layer.cornerRadius = 5;
    _recv_img.clipsToBounds = YES;
    _recv_img.contentMode = UIViewContentModeScaleAspectFill;
    
    PFFile *curr_usr_propic = [[PFUser currentUser] objectForKey:@"propic"];
    [_send_img sd_setImageWithURL:[NSURL URLWithString:curr_usr_propic.url]];
    
    _send_img.layer.cornerRadius = 5;
    _send_img.clipsToBounds = YES;
    _send_img.contentMode = UIViewContentModeScaleAspectFill;

    
    _recipient.backgroundColor = [UIColor clearColor];
    _amount.backgroundColor = [UIColor clearColor];
    _desc.backgroundColor = [UIColor clearColor];
    
    [_recipient setPlaceholder:@"Recipient" floatingTitle:@"Recipient"];
    [_amount setPlaceholder:@"Amount" floatingTitle:@"Amount"];
    [_desc setPlaceholder:@"Description" floatingTitle:@"Description"];
    
    _recipient.floatingLabelActiveTextColor = [UIColor colorWithRed:0.0/255.0f green:51.0/255.0f blue:102.0/255.0f alpha:1.0f];
    _amount.floatingLabelActiveTextColor = [UIColor colorWithRed:0.0/255.0f green:51.0/255.0f blue:102.0/255.0f alpha:1.0f];
    _desc.floatingLabelActiveTextColor = [UIColor colorWithRed:0.0/255.0f green:51.0/255.0f blue:102.0/255.0f alpha:1.0f];
    
    _recipient.delegate = self;
    _desc.delegate = self;

    _recipient.tag = 0;
    
    MMNumberKeyboard *keyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
    keyboard.allowsDecimalPoint = NO;
    keyboard.delegate = self;
    
    _amount.inputView = keyboard;
    [_recipient setReturnKeyType:UIReturnKeyDone];
    [_desc setReturnKeyType:UIReturnKeyDefault];
    
    [_recipient addTarget:self action:@selector(doneHit) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_recipient addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    [_hud setYOffset:-100.0f];

    success = false;
    
    if (self.sendToUser) {
        [_recipient setText:[NSString stringWithFormat:@"%@ %@", self.sendToUser[@"first"], self.sendToUser[@"last"]]];
        _sentence_lbl.text = [NSString stringWithFormat:@"%@ → %@", [PFUser currentUser][@"first"], self.sendToUser[@"first"]];
        
        PFFile *propic = self.sendToUser[@"propic"];
        [_recv_img sd_setImageWithURL:[NSURL URLWithString:propic.url]];
        
        [_amount becomeFirstResponder];
    } else {
        _sentence_lbl.text = [NSString stringWithFormat:@"%@ →", [PFUser currentUser][@"first"]];
        [_recipient becomeFirstResponder];
    }
    
    
    UIView *grr = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 264, self.view.frame.size.width, 264)];
    grr.backgroundColor = [YUtil theColor];
    [self.view addSubview:grr];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setNeedsStatusBarAppearanceUpdate];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![self.recipient isFirstResponder]) {
        [self.desc becomeFirstResponder];
    }
}

-(void) camera_btn_hit {
    CameraVC *cam = [[CameraVC alloc] init];
    cam.delegate = self;
    [self presentViewController:cam animated:YES completion:nil];
}

-(void) send_btn_hit {
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"";
    [_hud show:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self sendKarma];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (success == true) {
                _hud.mode = MBProgressHUDModeCustomView;
                _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
                _hud.labelText = @"Success!";
                __weak typeof(self) weakSelf = self;
                [_hud setCompletionBlock:^(){
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    [weakSelf.view endEditing:YES];
                    
                    MMDrawerController *drawer = (MMDrawerController *) weakSelf.presentingViewController;
                    UINavigationController *nav = (UINavigationController *) drawer.centerViewController;

                    [weakSelf dismissViewControllerAnimated:YES completion:^(){
                        if ([nav.childViewControllers.firstObject isKindOfClass:[FeedVC class]]) {
                            FeedVC *f = nav.childViewControllers.lastObject;
                            f.scrollToTop = YES;
                            [f loadObjects];
                        }
                    }];
                }];
                [_hud hide:YES afterDelay:1.0f];
            }
        });
    });
}

#pragma mark MediaPicker methods

-(void)didFinishWithImage:(UIImage *)image {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.photo = image;
    self.videoPath = nil;
}

-(void)didFinishWithVideo:(NSURL *)videoPath {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.videoPath = videoPath;
    self.photo = nil;
}

-(void) textFieldChanged {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if (evaluatedObject == nil ) {
            return NO;
        }
        
        if ([_recipient.text length] == 0) {
            return YES;
        }
        
        PFUser * obj = (PFUser *) evaluatedObject[@"toUser"];
        
        if (obj[@"first"] && obj[@"last"]) {
            NSString * fullName = [NSString stringWithFormat:@"%@ %@", obj[@"first"], obj[@"last"]];
            NSRange range = [fullName rangeOfString:_recipient.text options:NSCaseInsensitiveSearch];
            return range.location != NSNotFound;
        } else {
            return NO;
        }
    }];
    
    [_filteredObjects removeAllObjects];
    _filteredObjects = [[self.objects filteredArrayUsingPredicate:predicate] mutableCopy];
    [_friends reloadData];
}

-(void) doneHit {
    [_amount becomeFirstResponder];
}

-(BOOL)numberKeyboardShouldReturn:(MMNumberKeyboard *)numberKeyboard {
    [_desc becomeFirstResponder];
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField*)textField {
    // recipient
    if (textField.tag == 0) {
        [self.view addSubview:self.friends];
        
        if ([_recipient.text length] == 0) {
            [self loadObjects];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    // recipient
    if (textField.tag == 0) {
        [self.friends removeFromSuperview];
    }
    
    // check what is in recipient text
    
}

-(UITableView *) friends {
    if (!_friends) {
        _friends = [[UITableView alloc] initWithFrame:CGRectMake(0, 115, self.view.frame.size.width, self.view.frame.size.height - 115 - 216)];
        [_friends registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        _friends.dataSource = self;
        _friends.delegate = self;
    }
    return _friends;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        [_amount becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if(range.length + range.location > textView.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return newLength <= 120;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

-(void) sendKarma {
    
    if (!self.usernameToSend) {
        success = false;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"Recipient not set";

            [_hud show:YES];
            [_hud hide:YES afterDelay:2.0f];
        });
        return;
    }
    
    PFUser *sender = [PFUser currentUser];
    [sender fetch];
    
    NSString *recv_username = self.usernameToSend;
    PFQuery *usr_query = [PFUser query];
    [usr_query whereKey:@"username" equalTo:recv_username];
    
    PFUser *recipient = [usr_query getFirstObject];
    [recipient fetch];
    
    if (!recipient || [recv_username isEqualToString:[PFUser currentUser].username]) {
        success = false;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];

            _hud.mode = MBProgressHUDModeText;
            
            if ([recv_username isEqualToString:@""]) {
                _hud.labelText = @"Recipient not set";
            } else {
                _hud.labelText = @"Recipient not found";
            }
            [_hud show:YES];
            [_hud hide:YES afterDelay:2.0f];
        });
        return;
    }
    
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([_amount.text isEqualToString:@""] || !([_amount.text rangeOfCharacterFromSet:notDigits].location == NSNotFound)) {
        success = false;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];

            _hud.mode = MBProgressHUDModeText;

            if ([_amount.text isEqualToString:@""]) {
                _hud.labelText = @"Enter an amount";
            } else {
                _hud.labelText = @"Amount has invalid characters";
            }
            
            [_hud show:YES];
            [_hud hide:YES afterDelay:2.0f];
        });
        return;
    }
    
    int sender_karma = [[sender objectForKey:@"karma"] intValue];
    NSNumber *amount = [NSNumber numberWithInt:[_amount.text intValue]];
    
    if (amount.intValue > sender_karma) {
        success = false;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"You do not have enough karma";
            
            [_hud show:YES];
            [_hud hide:YES afterDelay:2.0f];
        });
        return;
    }
    
    if ([_desc.text isEqualToString:@""]) {
        success = false;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"Enter a description";
            
            [_hud show:YES];
            [_hud hide:YES afterDelay:2.0f];
        });
        return;
    }
    
    PFObject *post = [PFObject objectWithClassName:@"post"];
    post[@"text"] = _desc.text;
    post[@"giver"] = sender;
    post[@"taker"] = recipient;
    post[@"amt"] = [NSNumber numberWithInt:[_amount.text intValue]];
    
    if (self.photo) {
        NSData * photoData = UIImageJPEGRepresentation(self.photo, 0.6f);
        
        if (photoData.length > 10485760)  {
            success = false;
            return;
        }
        
        PFFile * photoFile = [PFFile fileWithData:photoData];
        post[@"photo"] = photoFile;
        post[@"isPhoto"] = @YES;
    } else if (self.videoPath) {
        NSData * videoData = [[NSFileManager defaultManager] contentsAtPath:[self.videoPath path]];
        
        PFFile * videoFile;
        if (videoData != nil) {
            videoFile = [PFFile fileWithName:@"flick.mp4" data:videoData];
            post[@"video"] = videoFile;
            post[@"isPhoto"] = @NO;
        }
    }
    
    NSError *err = nil;
    [post save:&err];
    
    if (err) {
        NSLog(@"%@", [err localizedDescription]);
    } else {
        success = true;
        sender[@"karma"] = [NSNumber numberWithInt:(sender_karma - amount.intValue)];
        [sender save];
        
        NSNumber *recipient_karma = [NSNumber numberWithInt:([[recipient objectForKey:@"karma"] intValue] + amount.intValue)];
        
        [PFCloud callFunction:@"updateKarmaForUser" withParameters:@{@"userId": recipient.objectId, @"karma": recipient_karma}];
    }
}


-(void) cancelBtnHit {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PFQueryStuff

- (PFQuery *)queryForTable {
    PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:kActivityClassKey];
    [followingActivitiesQuery whereKey:kActivityTypeKey equalTo:kActivityTypeFollow];
    [followingActivitiesQuery whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
    followingActivitiesQuery.cachePolicy = kPFCachePolicyNetworkOnly;

    [followingActivitiesQuery setCachePolicy:kPFCachePolicyNetworkOnly];
    [followingActivitiesQuery includeKey:@"toUser"];
    
    return followingActivitiesQuery;
}

- (BFTask<NSArray<__kindof PFObject *> *> *)loadObjects {
    return [self loadObjects:0 clear:YES];
}

- (BFTask<NSArray<__kindof PFObject *> *> *)loadObjects:(NSInteger)page clear:(BOOL)clear {
    
    PFQuery *query = [self queryForTable];
    
    BFTaskCompletionSource<NSArray<__kindof PFObject *> *> *source = [BFTaskCompletionSource taskCompletionSource];
    [query findObjectsInBackgroundWithBlock:^(NSArray *foundObjects, NSError *error) {

        if (error) {
            NSLog(@"Error loading objects");
        } else {
            
            if (clear) {
                [_mutableObjects removeAllObjects];
                [_filteredObjects removeAllObjects];
            }
            
            [_mutableObjects addObjectsFromArray:foundObjects];
            [_filteredObjects addObjectsFromArray:foundObjects];
            [_friends reloadData];
        }
        
        if (error) {
            [source trySetError:error];
        } else {
            [source trySetResult:foundObjects];
        }
    }];
    
    return source.task;
}

- (void)tableView:(UITableView *)tableView
    configureCell:(FriendCell *)cell
      atIndexPath:(NSIndexPath *)indexPath
           object:(PFObject *)object {
    
    PFUser *usa = object[@"toUser"];
    
    PFFile * propic = usa[@"propic"];
    [cell.usr_pro sd_setImageWithURL:[NSURL URLWithString:propic.url]];
    cell.username.text = [NSString stringWithFormat:@"%@ %@", usa[@"first"], usa[@"last"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (FriendCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    FriendCell *cell = (FriendCell *) [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    [self tableView:tableView configureCell:cell atIndexPath:indexPath object:object];
    
    return cell;
}

- (NSArray<__kindof PFObject *> *)objects {
    return _mutableObjects;
}

- (NSArray<__kindof PFObject *> *) filteredObjs {
    return _filteredObjects;
}


- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    return self.filteredObjs[indexPath.row];
}

#pragma mark - UITableViewDataSource

- (FriendCell *)tableView:(UITableView *)otherTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:otherTableView
         cellForRowAtIndexPath:indexPath
                        object:[self objectAtIndexPath:indexPath]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFUser *user = [self.objects objectAtIndex:indexPath.row][@"toUser"];
    PFFile * propic = user[@"propic"];
    
    [_recipient setText:[NSString stringWithFormat:@"%@ %@", user[@"first"], user[@"last"]]];
    self.usernameToSend = user.username;
    [_amount becomeFirstResponder];
    
    [_recv_img sd_setImageWithURL:[NSURL URLWithString:propic.url]];
    _sentence_lbl.text = [NSString stringWithFormat:@"%@ → %@", [PFUser currentUser][@"first"], user[@"first"]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filteredObjs count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

@end
