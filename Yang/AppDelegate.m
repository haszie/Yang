//
//  AppDelegate.m
//  Yang
//
//  Created by Biggie Smallz on 1/11/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "AppDelegate.h"

@import LNNotificationsUI;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [Parse setApplicationId:@"s2pr5k1K1w3Vg3EiYw4oexB4UzrcPPUlJQU2h7Ry"
                  clientKey:@"Hbr8AOdETokyms4BQbyaKHJOvKShTMQGX5ZaOcK2"];
    
    [[UINavigationBar appearance] setBarTintColor:[YUtil theColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"OpenSans" size:14.0f]}];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    
    [[UIButton appearance] setTintColor:[UIColor lightGrayColor]];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"OpenSans" size:14.0f]
       } forState:UIControlStateNormal];
        
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([PFUser currentUser] && [[PFUser currentUser] isAuthenticated]) {
        [[PFUser currentUser] fetchInBackground];

        //HomeFeedVC *home = [[HomeFeedVC alloc] initWithStyle:UITableViewStylePlain];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[MenuVC home]];
        
        MenuVC *menu = [[MenuVC alloc] init];
        MainVC *drawerController = [[MainVC alloc] initWithCenterViewController:nav leftDrawerViewController:menu];
        
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
        
        self.window.rootViewController = drawerController;
    } else {
       LoginVC *lgvc = [[LoginVC alloc] init];
       self.window.rootViewController = lgvc;
    }

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *installation = [PFInstallation currentInstallation];
    [installation setDeviceTokenFromData:deviceToken];
    installation.channels = @[ @"global" ];
    if ([PFUser currentUser]) {
        [installation setObject:[PFUser currentUser].objectId forKey:@"user"];
    }
    [installation saveInBackground];
    
    [[LNNotificationCenter defaultCenter] registerApplicationWithIdentifier:@"yang" name:@"Yang" icon:[UIImage imageNamed:@"app_60"] defaultSettings:[LNNotificationAppSettings defaultNotificationAppSettings]];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *) notificationData {

    if (application.applicationState != UIApplicationStateActive) {
        [self handleNotificationCallback:notificationData];
    } else {
        NSString *message = [[notificationData objectForKey:@"aps"] objectForKey:@"alert"];
        LNNotification* notification = [LNNotification notificationWithMessage:message];
        notification.defaultAction = [LNNotificationAction actionWithTitle:@"Open" handler:^(LNNotificationAction *action) {
            [self handleNotificationCallback:notificationData];
        }];
        [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"yang"];
    }
}

-(void) handleNotificationCallback:(NSDictionary *) notificationData {
    
    NSString * type = [notificationData objectForKey:@"type"];

    if ([type isEqualToString:@"karma"] || [type isEqualToString:@"upvote"]) {
        NSString * objId = [notificationData objectForKey:@"postId"];

        PFObject *obj = [PFObject objectWithoutDataWithClassName:@"post" objectId:objId];
        
        [obj fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            [[YUtil getTheDrawer] closeDrawerAnimated:YES completion:^(BOOL finished) {
                PostVC *pvc = [[PostVC alloc] initWithPFObject:object withHeight:[YUtil calcHeight:object withFrame:self.window.frame]];
                UINavigationController *nav = (UINavigationController *) [YUtil getTheDrawer].centerViewController;
                pvc.addMenuButton = YES;
                
                [nav setViewControllers:@[pvc] animated:YES];
            }];
        }];
    } else if ([type isEqualToString:@"follow"]) {
        NSString * objId = [notificationData objectForKey:@"fromUserId"];

        PFUser *usr = (PFUser *)[PFObject objectWithoutDataWithClassName:@"_User" objectId:objId];
        
        [usr fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            [[YUtil getTheDrawer] closeDrawerAnimated:YES completion:^(BOOL finished) {
                UserProfileVC *userProfile = [[UserProfileVC alloc] initWithUser:(PFUser *) object];
                UINavigationController *nav = (UINavigationController *) [YUtil getTheDrawer].centerViewController;
                userProfile.addMenuButton = YES;
                
                [nav setViewControllers:@[userProfile] animated:YES];
            }];
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
