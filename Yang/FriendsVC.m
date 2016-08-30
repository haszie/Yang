//
//  FriendsVC.m
//  Yang
//
//  Created by Biggie Smallz on 2/17/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "FriendsVC.h"

@interface FriendsVC () {
    NSMutableArray<APContact *> *_mutableContacts;
    NSMutableArray<APContact *> *_filteredContacts;
    NSMutableDictionary *_recordIdToProfileInfo;
    NSMutableDictionary *_operations;
    NSOperationQueue *_queue;
}

@end

@implementation FriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mutableContacts = [NSMutableArray array];
    _filteredContacts = [NSMutableArray array];
    _recordIdToProfileInfo = [NSMutableDictionary dictionary];
    _operations = [NSMutableDictionary dictionary];
    _queue = [[NSOperationQueue alloc] init];
    _queue.maxConcurrentOperationCount = 32;
    
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
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.definesPresentationContext = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

-(void) menuButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - Search

-(void) filterContentForSearchText:(NSString *) text {
    if (![text containsString:@"'"]) {
        NSString *predicateString = [NSString stringWithFormat:@"name.compositeName contains[c] '%@'", text];
        NSPredicate *pred = [NSPredicate predicateWithFormat:predicateString];
        _filteredContacts = [[_mutableContacts filteredArrayUsingPredicate:pred] mutableCopy];
        [self.tableView reloadData];
    }
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self filterContentForSearchText:searchController.searchBar.text];
}

#pragma mark - APContact loadings

- (NSArray<__kindof APContact *> *)contacts {
    return [_mutableContacts copy];
}

- (nullable APContact *) contactAtIndexPath:(nullable NSIndexPath *)indexPath {
    if ([self.searchController isActive] && ![self.searchController.searchBar.text isEqualToString:@""]) {
        if (indexPath.row < _filteredContacts.count) {
        return _filteredContacts[indexPath.row];
        } else {
            return nil;
        }
    } else {
        if (indexPath.row < self.contacts.count) {
        return self.contacts[indexPath.row];
        } else {
            return nil;
        }
    }
}

- (nullable BFTask<NSArray<__kindof APContact *> *> *)loadContacts {
    BFTaskCompletionSource<NSArray<__kindof APContact *> *> *source = [BFTaskCompletionSource taskCompletionSource];
    [self.book loadContacts:^(NSArray<APContact *> * _Nullable contacts, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@\n", error.localizedDescription);
        } else {
            
            [_mutableContacts addObjectsFromArray:contacts];
            [self.tableView reloadData];
        }
        
        if (error) {
            [source trySetError:error];
        } else {
            [source trySetResult:contacts];
        }
    }];
    
    return source.task;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.searchController isActive] && ![self.searchController.searchBar.text isEqualToString:@""]) {
        return [_filteredContacts count];
    } else {
        return [self.contacts count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    APContact *contact = [self contactAtIndexPath:indexPath];
    
    NSOperation *op = [_operations objectForKey:contact.recordID];
    if (op && contact.recordID) {
        [op cancel];
        [_operations removeObjectForKey:contact.recordID];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    APContact *contact = [self contactAtIndexPath:indexPath];
    PhoneFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhoneFriendsCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[PhoneFriendsCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70.0f)];
    }
    
    ProfileInfo *info = [_recordIdToProfileInfo objectForKey:contact.recordID];
    
    if (![info isComplete]) {
        if (!info) {
            info = [[ProfileInfo alloc] init];
            info.isComplete = NO;
            info.contact = contact;
            
            [_recordIdToProfileInfo setObject:info forKey:contact.recordID];
            
            NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
                if (contact.phones != nil && contact.phones.count != 0) {
                    NSMutableArray *checks = [[NSMutableArray alloc] init];
                    
                    int i;
                    for (i = 0; i < contact.phones.count; i++) {
                        NSString *numba = [[contact.phones[i].number componentsSeparatedByCharactersInSet:
                                            [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                           componentsJoinedByString:@""];
                        
                        if (numba.length == 11) {
                            numba = [numba substringFromIndex:1];
                        }
                        checks[i] = [[PFQuery queryWithClassName:@"_User"] whereKey:@"username" equalTo:numba];
                    }
                    
                    PFQuery *check_user = [PFQuery orQueryWithSubqueries:[checks copy]];
                    [check_user setCachePolicy:kPFCachePolicyNetworkOnly];
                    
                    [check_user getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                        if (!error) {
                            info.isYangActive = YES;
                            info.theUser = (PFUser *) object;
                        } else {
                            info.isYangActive = NO;
                        }
                        PhoneFriendsCell *fvc = [self.tableView cellForRowAtIndexPath:indexPath];
                        [self configureCell:fvc withInfo:info];
                    }];
                }
            }];
            [op setCompletionBlock:^{
                [_operations removeObjectForKey:info];
                info.isComplete = YES;
            }];
            [_queue addOperation:op];
            [_operations setObject:op forKey:contact.recordID];
        }
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
        
        PFObject *referal = [PFObject objectWithClassName:@"referal"];
        [referal setObject:[PFUser currentUser] forKey:@"fromUser"];
        [referal setObject:numba forKey:@"toNumber"];
        
        [referal saveInBackground];
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
