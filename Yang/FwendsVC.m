//
//  FwendsVC.m
//  Yang
//
//  Created by Biggie Smallz on 6/7/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "FwendsVC.h"

@interface FwendsVC () {
    NSMutableArray<APContact *> *_mutableContacts;
    NSMutableArray<ProfileInfo *> *_withZen;
    NSMutableArray<ProfileInfo *> *_futureYangMasters;
}

@end

@implementation FwendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView * frame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIImage *logo = [UIImage imageNamed:@"friends"];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:logo];
    logoView.frame = CGRectMake(75, 0, 150, 44);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    
    [frame addSubview:logoView];
    self.navigationItem.titleView = logoView;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    button.userInteractionEnabled = NO;
    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;

    
    [self.tableView registerClass:[PhoneFriendsCell class] forCellReuseIdentifier:@"PhoneFriendsCell"];

    _mutableContacts = [NSMutableArray array];
    _withZen = [NSMutableArray array];
    _futureYangMasters = [NSMutableArray array];
    
    self.book = [[APAddressBook alloc] init];
    self.book.fieldsMask = APContactFieldName | APContactFieldPhonesOnly;
    self.book.sortDescriptors = @[
                                  [NSSortDescriptor sortDescriptorWithKey:@"name.compositeName" ascending:YES]
                                  ];
    
    self.book.filterBlock = ^BOOL(APContact *contact)
    {
        return contact.phones.count > 0;
        return contact.name != nil;
    };
    
    UIImage *menu_img = [UIImage imageNamed:@"menu-alt"];
    CGRect menu_frame = CGRectMake(0, 0, 22, 22);
    
    UIButton *menu_btn = [[UIButton alloc] initWithFrame:menu_frame];
    [menu_btn addTarget:self action:@selector(menuButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [menu_btn setImage:menu_img forState:UIControlStateNormal];
    
    UIBarButtonItem *menu_itm= [[UIBarButtonItem alloc] initWithCustomView:menu_btn];
    
    self.navigationItem.leftBarButtonItem = menu_itm;
    
    [self.tableView registerClass:[PhoneFriendsCell class] forCellReuseIdentifier:@"PhoneFriendsCell"];
    
    if ([APAddressBook access] == APAddressBookAccessUnknown) {
        [self.book requestAccess:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [self loadContacts];
            } else {
                UILabel * bg = [[UILabel alloc] initWithFrame:CGRectMake(64.0f, self.view.frame.size.height / 2.0f - 96.0f, self.view.frame.size.width - 128.0f, 120.0f)];
                [bg setFont:[UIFont fontWithName:@"OpenSans" size:15.0f]];
                bg.text = @"This app needs your permission to access your contacts. Go to your phone settings and give approval so you can add friends by phone number.";
                bg.numberOfLines = 0;
                [bg sizeToFit];
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                [self.view addSubview:bg];
            }
        }];
    } else if ([APAddressBook access] == APAddressBookAccessGranted) {
        [self loadContacts];
    } else if ([APAddressBook access] == APAddressBookAccessDenied) {
        UILabel * bg = [[UILabel alloc] initWithFrame:CGRectMake(64.0f, self.view.frame.size.height / 2.0f - 96.0f, self.tableView.frame.size.width - 128.0f, 120.0f)];
        [bg setFont:[UIFont fontWithName:@"OpenSans" size:15.0f]];
        bg.text = @"This app needs your permission to access your contacts. Go to your phone settings and give approval so you can add friends by phone number.";
        bg.numberOfLines = 0;
        [bg sizeToFit];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:bg];
    }
}

-(void) menuButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - Contacts

- (NSArray<__kindof APContact *> *)contacts {
    return [_mutableContacts copy];
}

- (nullable BFTask<NSArray<__kindof APContact *> *> *)loadContacts {
    BFTaskCompletionSource<NSArray<__kindof APContact *> *> *source = [BFTaskCompletionSource taskCompletionSource];
    [self.book loadContacts:^(NSArray<APContact *> * _Nullable contacts, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@\n", error.localizedDescription);
        } else {
            [_mutableContacts addObjectsFromArray:contacts];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                [self splitContacts];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.tableView reloadData];
                });
            });
        }
        
        if (error) {
            [source trySetError:error];
        } else {
            [source trySetResult:contacts];
        }
    }];
    
    return source.task;
}

-(void) splitContacts {
    
    NSMutableArray *checks = [[NSMutableArray alloc] init];

    for (int i = 0; i < self.contacts.count; i++) {
        if (_mutableContacts[i].phones != nil && self.contacts[i].phones.count != 0) {
            for (int j = 0; j < self.contacts[i].phones.count; j++) {
                NSString *numba = [[self.contacts[i].phones[j].number componentsSeparatedByCharactersInSet:
                                    [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                   componentsJoinedByString:@""];
                
                if (numba.length == 11) {
                    numba = [numba substringFromIndex:1];
                }
                
                if (numba.length != 0 && ![numba isEqualToString:[PFUser currentUser].username]) {
                    [checks addObject:numba];
                }
            }
        }
    }
    
    PFQuery *check_user = [PFQuery queryWithClassName:@"_User"];
    [check_user whereKey:@"username" containedIn:checks];
    [check_user setCachePolicy:kPFCachePolicyNetworkOnly];
    [check_user orderByAscending:@"first"];
    
    NSError *error;
    NSArray<__kindof PFUser *> *activeYangers = [check_user findObjects:&error];
                              
    if (!error) {
        for (int i = 0; i < self.contacts.count; i++) {
            ProfileInfo *info = [[ProfileInfo alloc] init];
            info.contact = self.contacts[i];

            BOOL found = false;
            
            int aye = 0;
            for (int j = 0; j < activeYangers.count; j++) {
                if (info.contact.phones != nil && info.contact.phones.count != 0) {
                    int i;
                    for (i = 0; i < info.contact.phones.count; i++) {
                        NSString *numba = [[info.contact.phones[i].number componentsSeparatedByCharactersInSet:
                                            [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                           componentsJoinedByString:@""];
                        
                        if (numba.length == 11) {
                            numba = [numba substringFromIndex:1];
                        }
                        if ([activeYangers[j].username isEqualToString:numba]) {
                            found = true;
                            break;
                        }
                    }
                    if (found) {
                        aye = j;
                        break;
                    }
                }
            }
            
            if (found) {
                info.isYangActive = YES;
                info.theUser = activeYangers[aye];
                [_withZen addObject:info];
            } else {
                info.isYangActive = NO;
                [_futureYangMasters addObject:info];
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [_withZen count];
    } else {
        return [_futureYangMasters count];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Friends on Yang";
    } else {
        return @"Invite to Yang";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PhoneFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhoneFriendsCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[PhoneFriendsCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70.0f)];
    }
    
    ProfileInfo *info;
    if (indexPath.section == 0) {
        info = _withZen[indexPath.row];
    } else {
        info = _futureYangMasters[indexPath.row];
    }
    
    [self configureCell:cell withInfo:info];
    
    return cell;
}

-(void) configureCell:(PhoneFriendsCell *) cell withInfo:(ProfileInfo *) info {
    
    cell.displayName.text = info.contact.name.compositeName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.propic.delegate = self;
    cell.delegate = self;
    cell.info = info;
    
    if (info.isYangActive) {
        
        [cell.propic setTheUser:info.theUser];
        
        [cell.followButton setFrame:CGRectMake(cell.frame.size.width - 108.0f, 17.0, 100.0, 35.0f)];
        
        cell.followButton.hidden = NO;
        cell.inviteButton.hidden = YES;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            BOOL followStatus = [YUtil currentUserDoesFollowUser:info.theUser];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [cell.followButton setSelected:followStatus];
            });
        });
    } else {
        
        [cell.inviteButton setFrame:CGRectMake(cell.frame.size.width - 108.0f, 17.0, 100.0, 35.0f)];
        
        cell.followButton.hidden = YES;
        cell.inviteButton.hidden = NO;
        
        [cell.propic setImage:[UIImage imageNamed:@"usr"] forState:UIControlStateNormal];
    }
}

-(void)didHitFollowButton:(UIButton *)button forFriendsCell:(PhoneFriendsCell *)cell withInfo:(ProfileInfo *)info {
    PFUser *theUser = info.theUser;
    if (button.isSelected) {
        [YUtil unfollowUserEventually:theUser];
    } else {
        [YUtil followUserEventually:theUser block:nil];
    }
    [button setSelected:!button.isSelected];
}

-(void)didHitInviteButton:(UIButton *)button forFriendsCell:(PhoneFriendsCell *)cell withInfo:(ProfileInfo *)info {
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[[info.contact.phones firstObject].number];
    NSString *message = @"You should check out this new app Yang on the app store, it's pretty juicy.";
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    self.phoneNumberReferred = [info.contact.phones firstObject].number;
    
    [self presentViewController:messageController animated:YES completion:nil];
}

-(void) didTapUserPic:(ProPicIV *) thePic {
    if (thePic.theUser != nil) {
        UserProfileVC * uvc = [[UserProfileVC alloc] initWithUser:thePic.theUser];
        [self.navigationController pushViewController:uvc animated:YES];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    if(result == MessageComposeResultFailed) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
    } else if (result == MessageComposeResultSent) {
        
        NSString *numba = [[self.phoneNumberReferred componentsSeparatedByCharactersInSet:
                            [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                           componentsJoinedByString:@""];
        
        [PFCloud callFunctionInBackground:@"refer" withParameters:@{ @"phoneNumber": numba }];
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
