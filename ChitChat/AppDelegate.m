//
//  AppDelegate.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/12/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // load base data
    [[GlobalData sharedInstance] loadBaseData];

    // load config data
    [[GlobalData sharedInstance] loadConfigData];
    
    // setting status bar style
    [application setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    // setting for pushnotification
    [self initPushNotificationForApplication:application];
    
    // init svprogresshud
    [self initSVProgressHUD];
    
    // get device id
    [self initDeviceID];
    
    // init quickblox setting
    [self initQuickBlox];
    
    // init push notification message
    [FTIndicator setIndicatorStyle:UIBlurEffectStyleDark];
    
    // init fabric for crashlytics
    [Fabric with:@[[Crashlytics class]]];
    
    // one signal handler
    [self initOneSignalWithLaunchOptions:launchOptions];
    
    // init tune for mat
    [self initTune];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    if ([QMServicesManager instance].chatService.chatConnectionState != QMChatConnectionStateDisconnected) {
        
        [[QMServicesManager instance].chatService disconnectWithCompletionBlock:nil];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([GlobalData sharedInstance].g_selfUser.user_id > 0) {
     
        [self checkNotification];
        
        [[QMServicesManager instance].chatService connectWithCompletionBlock:^(NSError * _Nullable error) {
            
            if (error) {
                
                [[WebService sharedInstance] signInQBUserWithUserObj:[GlobalData sharedInstance].g_selfUser
                                                             Success:^(id response) {
                                                                 
                                                                 // register subscription for push notification
                                                                 [[GlobalData sharedInstance] createQBMSubscription];
                                                                 
                                                             } Failure:^(NSString *error) {
                                                                 
                                                                 SHOW_ERROR_MESSAGE(error);
                                                             }];
            }
        }];
        
        // check user auto renewal
        [[GlobalData sharedInstance] checkAutoRenewal];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [Tune measureSession];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    if ([QMServicesManager instance].chatService.chatConnectionState != QMChatConnectionStateDisconnected) {
        
        [[QMServicesManager instance].chatService disconnectWithCompletionBlock:nil];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    
    NSString *strDeviceToken = [[NSString alloc]
                                initWithString: [[[[newDeviceToken description]
                                                   stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                                                 stringByReplacingOccurrencesOfString: @" " withString: @""]];
    
    if ([[GlobalData sharedInstance].g_strDeviceToken isEqualToString:strDeviceToken]) return;
    
    // Save deviceToken
    [GlobalData sharedInstance].g_strDeviceToken = strDeviceToken;
    [[GlobalData sharedInstance] saveConfigData];
    
    [GlobalData sharedInstance].g_newDeviceToken = newDeviceToken;
    [[GlobalData sharedInstance] createQBMSubscription];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    if (![NSObject isValid:[GlobalData sharedInstance].g_strDeviceToken]) {
        
        [GlobalData sharedInstance].g_strDeviceToken = @"FAILED";
    }
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // check chat notification
    if ([NSObject isValid:userInfo[@"dialog_id"]]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_DID_RECEIVE_NEW_CHAT object:nil];
    }
}

// for iOS < 9.0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication  annotation:(id)annotation {
    
    // when the app is opened due to a deep link, call the Tune deep link setter
    [Tune applicationDidOpenURL:url.absoluteString sourceApplication:sourceApplication];
    
    return YES;
}

// for iOS >= 9.0
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    
    // when the app is opened due to a deep link, call the Tune deep link setter
    NSString *sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    
    [Tune applicationDidOpenURL:url.absoluteString sourceApplication:sourceApplication];
    
    return YES;
}


# pragma mark - Initailzie Handler

# pragma mark - Initialize HUD

- (void) initSVProgressHUD {
    
    // SVProgressHUD
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:3.0f];
}

# pragma mark - Initialize Push Notification

- (void) initPushNotificationForApplication:(UIApplication *) application {
    
#if IPHONE_OS_VERSION_MAX_ALLOWED >= IPHONE_8_0
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge
                                                                            | UIRemoteNotificationTypeSound
                                                                            | UIRemoteNotificationTypeAlert)];
#endif
    
}

# pragma mark - Initialize Device ID

- (void) initDeviceID {
    
#if TARGET_IPHONE_SIMULATOR
    [GlobalData sharedInstance].g_strDeviceID = @"UDID00123456789";
#else
    [GlobalData sharedInstance].g_strDeviceID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
#endif
}

# pragma mark - Initialize QuickBlox

- (void) initQuickBlox {
    
    // Set QuickBlox credentials (You must create application in admin.quickblox.com)
    [QBSettings setApplicationID:QB_APP_ID];
    [QBSettings setAuthKey:QB_AUTH_KEY];
    [QBSettings setAuthSecret:QB_AUTH_SECRET];
    [QBSettings setAccountKey:QB_ACCOUNT_KEY];
    
    // Set Communcation Time
    [QBSettings setKeepAliveInterval:30];
    [QBSettings setAutoReconnectEnabled:YES];
    
    // Enabling carbons for chat
    [QBSettings setCarbonsEnabled:YES];
    
    // Enables Quickblox REST API calls debug console output
    [QBSettings setLogLevel:QBLogLevelNothing];
    
    // Enables detailed XMPP logging in console output
    [QBSettings enableXMPPLogging];
}

# pragma mark - Check Notification Handler

- (void) checkNotification {
    
    [[WebService sharedInstance] checkNotificationWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                                     Success:^(id response) {
                                                         
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_GET_UNREAD_NOTIFICATIONS
                                                                                                             object:nil
                                                                                                           userInfo:nil];
                                                         
                                                     } Failure:^(NSString *error) {
                                                        
                                                         SHOW_ERROR_MESSAGE(error);
                                                     }];
}


# pragma mark - Initalize One Signal Handler

- (void) initOneSignalWithLaunchOptions:(NSDictionary *)launchOptions {
    
    // init one signal
    [OneSignal initWithLaunchOptions:launchOptions
                               appId:ONESIGNAL_APP_ID
          handleNotificationReceived:^(OSNotification *notification) {
              
              [FTIndicator showNotificationWithImage:[UIImage imageNamed:@"ic_notification"]
                                               title:APP_NAME
                                             message:notification.payload.title];
              
          } handleNotificationAction:^(OSNotificationOpenedResult *result) {
              
          } settings:@{kOSSettingsKeyInAppAlerts : @NO, kOSSettingsKeyAutoPrompt : @YES}];
    
    
    // register user id
    [OneSignal IdsAvailable:^(NSString *userId, NSString *pushToken) {

        [GlobalData sharedInstance].g_strOSUserId = userId;
        if ([GlobalData sharedInstance].g_selfUser.user_id.integerValue > 0) {
            
            [[WebService sharedInstance] registerOneSignalUserWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                                         OneSignalUserID:userId
                                                                 Success:^(id response) {
                                                                     
                                                                 } Failure:^(NSString *error) {
                                                                     
                                                                     SHOW_ERROR_MESSAGE(error);
                                                                 }];
        }
    }];
}

# pragma mark - Initialize Tune for MAT Handler

- (void) initTune {
    
    [Tune initializeWithTuneAdvertiserId:MAT_ADVERTISER_ID
                       tuneConversionKey:MAT_CONVERSION_KEY];
}

@end
