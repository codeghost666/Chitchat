//
//  GlobalData.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/12/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "GlobalData.h"

@implementation GlobalData

static GlobalData *_globalData = nil;

+ (GlobalData *) sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_globalData == nil) {
            
            _globalData = [[self alloc] init]; // assignment not done here
        }
    });
    
    return _globalData;
}

- (id) init {

    self = [super init];
    
    if (self) {
        
        
    }
    
    return self;
}

# pragma mark - 
# pragma mark - Check Jailbroken Phone
- (BOOL) isJailbrokenPhone {
    
    return [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"];
}

# pragma mark - Manipulation Base and Config Datas
- (void) loadBaseData {
    
    // get emoji list from server
    [[WebService sharedInstance] getEmojiListWithSuccess:^(id response) {
        
        [GlobalData sharedInstance].g_aryEmojis = (NSArray *) response;
        
    } Failure:^(NSString *error) {
       
        SHOW_ERROR_MESSAGE(error);
    }];
    
    // get in app data list from server
    [[WebService sharedInstance] getInAppDataWithSuccess:^(id response) {
        
        NSDictionary *dictResult = (NSDictionary *) response;
        NSMutableArray *aryData = [NSMutableArray new];
        for (NSDictionary *dict in dictResult[@"buycoins"]) {
            
            IAPObj *iapObj = [IAPObj instanceWithDict:dict];
            
            if (iapObj.inapp_auto_renewal.boolValue) {
                
                [GlobalData sharedInstance].g_vipIAP = iapObj;
            }
            else {
                
                [aryData addObject:iapObj];
            }
        }
        
        [GlobalData sharedInstance].g_aryInApps = (NSArray *) aryData;
        
        // set free coin shows flag
        [GlobalData sharedInstance].g_bShowFreeCoins = [dictResult[@"freecoins_show"] boolValue];
        
        // init iap
        [self initIAP];
        
    } Failure:^(NSString *error) {
       
        SHOW_ERROR_MESSAGE(error);
    }];
}

- (void) loadConfigData {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (userDefaults) {

        // load user data
        NSDictionary *dictUser = [userDefaults objectForKey:CONFIG_KEY_USER];
        [GlobalData sharedInstance].g_selfUser = [UserObj instanceWithDict:dictUser];
        
        // load selected location
        NSDictionary *dictLocation = [userDefaults objectForKey:CONFIG_KEY_LOCATION];
        [GlobalData sharedInstance].g_selectedLocation = [LocationObj instanceWithDict:dictLocation];
        
        // load device token
        [GlobalData sharedInstance].g_strDeviceToken = [userDefaults objectForKey:CONFIG_KEY_DEVICETOKEN];
    }
}

- (void) saveConfigData {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    @synchronized(userDefaults) {
        
        if (userDefaults) {
            
            NSDictionary *dictUser = [GlobalData sharedInstance].g_selfUser.currentDict;
            [userDefaults setObject:dictUser forKey:CONFIG_KEY_USER];
            
            NSDictionary *dictLocation = [GlobalData sharedInstance].g_selectedLocation.currentDict;
            [userDefaults setObject:dictLocation forKey:CONFIG_KEY_LOCATION];
            
            [userDefaults setObject:[GlobalData sharedInstance].g_strDeviceToken forKey:CONFIG_KEY_DEVICETOKEN];
            
            [userDefaults synchronize];
        }
    }
}

# pragma mark - Get Formatted String with Count
- (NSString *) formattedStringWithCount:(int) nCount {
    
    NSString *formattedString = nil;
    
    if (nCount / 1000000000 > 0) {
        
        formattedString = [NSString stringWithFormat:@"%.1f G", (float)nCount / 1000000000];
    }
    else if (nCount / 1000000 > 0) {
        
        formattedString = [NSString stringWithFormat:@"%.1f M", (float)nCount / 1000000];
    }
    else if (nCount / 1000 > 0) {
        
        formattedString = [NSString stringWithFormat:@"%.1f K", (float)nCount / 1000];
    }
    else {
        
        formattedString = [NSString stringWithFormat:@"%d", nCount];
    }
    
    return formattedString;
}

# pragma mark - Initialize In App Purchase
- (void) initIAP {
    
    NSMutableSet *dataSet = [NSMutableSet new];
    for (IAPObj *iapObj in [GlobalData sharedInstance].g_aryInApps) {
        
        [dataSet addObject:iapObj.inapp_code_ios];
    }
    
    [dataSet addObject:[GlobalData sharedInstance].g_vipIAP.inapp_code_ios];
    
    [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    
#ifdef DEVELOPMENT
    [IAPShare sharedHelper].iap.production = NO;
#else
    [IAPShare sharedHelper].iap.production = YES;
#endif
    
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest *request, SKProductsResponse *response) {

        if (response > 0) {
            
            for (SKProduct *product in [IAPShare sharedHelper].iap.products) {
                
                BOOL bValid = NO;
                for (IAPObj *iapObj in [GlobalData sharedInstance].g_aryInApps) {
                    
                    if ([iapObj.inapp_code_ios isEqualToString:product.productIdentifier]) {
                        
                        iapObj.inapp_product = product;
                        bValid = YES;
                        break;
                    }
                }
                
                if (bValid) continue;
                
                if ([[GlobalData sharedInstance].g_vipIAP.inapp_code_ios isEqualToString:product.productIdentifier]) {
                    
                    [GlobalData sharedInstance].g_vipIAP.inapp_product = product;
                }
            }

            [self checkAutoRenewal];
        }
        else {
            
            SHOW_ERROR_MESSAGE(response.description);
        }
    }];
}

# pragma mark - Check Auto Renewal for VIP Handler

- (void) checkAutoRenewal {
    
    if ([GlobalData sharedInstance].g_selfUser.user_gender.integerValue == UserGenderMale) {
        
        if ([NSObject isValid:[GlobalData sharedInstance].g_vipIAP]) {
            
            NSData *receipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
            
            if ([NSObject isValid:receipt]) {
             
                NSString *receipt_data = [NSString base64StringFromData:receipt length:[receipt length]];
                
                SHOW_WAIT_MESSAGE;
                
                [[WebService sharedInstance] verifyReceiptWithReceiptData:receipt_data
                                                           ProductionMode:@([IAPShare sharedHelper].iap.production)
                                                               DeviceType:@(1)
                                                                  Success:^(id response) {
                                                            
                                                                      DISMISS_MESSAGE;
                                                                      
                                                                      ReceiptObj *receiptObj = (ReceiptObj *) response;
                                                                      
                                                                      if ([[NSDate date] compare:receiptObj.expires_date] == NSOrderedDescending) {
                                                                          
                                                                          [GlobalData sharedInstance].g_bVIPUser = NO;
                                                                      }
                                                                      else {
                                                                          
                                                                          [GlobalData sharedInstance].g_bVIPUser = YES;

                                                                          // check new subscript processed
                                                                          NSString *expire_date = [[NSUserDefaults standardUserDefaults] stringForKey:CONFIG_KEY_SUBSCRIPT_EXPIREDATE];
                                                                          NSString *receipt_expire = [receiptObj.expires_date formattedDateWithFormat:FORMAT_DATE timeZone:ADJUST_TIMEZONE(@"UTC")];

                                                                          if (![expire_date isEqualToString:receipt_expire]) {
                                                                              
                                                                              // save current expire date
                                                                              [[NSUserDefaults standardUserDefaults] setObject:receipt_expire forKey:CONFIG_KEY_SUBSCRIPT_EXPIREDATE];
                                                                              [[NSUserDefaults standardUserDefaults] synchronize];
                                                                              
                                                                              
                                                                              if ([NSObject isValid:expire_date] && expire_date.length > 0)
                                                                                  [self measurePurchaseEvent];
                                                                          }
                                                                      }
                                                                      
                                                                      [self updateVIPUser];
                                                                      
                                                                  } Failure:^(NSString *error) {
                                                                      
                                                                      SHOW_ERROR_MESSAGE(error);
                                                                      
                                                                      [GlobalData sharedInstance].g_bVIPUser = NO;
                                                                      
                                                                      [self updateVIPUser];
                                                                  }];
            }
            else {
                
                [GlobalData sharedInstance].g_bVIPUser = NO;
                
                [self updateVIPUser];
            }
        }
    }
}

# pragma mark - Update VIP User Handler

- (void) updateVIPUser {
    
    // update vip user
    [[WebService sharedInstance] updateVIPUserWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                                     VIP:@([GlobalData sharedInstance].g_bVIPUser)
                                                 Success:^(id response) {
                                                     
                                                 } Failure:^(NSString *error) {
                                                     
                                                     SHOW_ERROR_MESSAGE(error);
                                                 }];
}

# pragma mark - Create QBMSubscription Handler
- (void) createQBMSubscription {
    
    // subscribing for push notification
    
    QBMSubscription *subscription = [QBMSubscription subscription];
    subscription.notificationChannel = QBMNotificationChannelAPNS;
    subscription.deviceUDID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];;
    subscription.deviceToken = [GlobalData sharedInstance].g_newDeviceToken;
    [QBRequest createSubscription:subscription successBlock:^(QBResponse * _Nonnull response, NSArray<QBMSubscription *> * _Nullable objects) {
        
    } errorBlock:^(QBResponse * _Nonnull response) {
        
    }];
}


# pragma mark - Tune for MAT Handler

- (void) measurePurchaseEvent {
    
    TuneEvent *event = [TuneEvent eventWithName:TUNE_EVENT_PURCHASE];
    event.refId = [GlobalData sharedInstance].g_selfUser.user_id.stringValue;
    TuneEventItem *item = [TuneEventItem eventItemWithName:@"VIP" unitPrice:39.99f quantity:1];
    event.eventItems = @[item];
    [Tune measureEvent:event];
}

@end
