//
//  GlobalData.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/12/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalData : NSObject

+ (GlobalData *) sharedInstance;

- (BOOL) isJailbrokenPhone;

- (void) loadBaseData;
- (void) loadConfigData;
- (void) saveConfigData;

- (NSString *) formattedStringWithCount:(int) nCount;
- (void) checkAutoRenewal;

- (void) createQBMSubscription;
- (void) measurePurchaseEvent;

@property (retain, nonatomic) UserObj       *g_selfUser;
@property (retain, nonatomic) LocationObj   *g_selectedLocation;
@property (retain, nonatomic) IAPObj        *g_vipIAP;
@property (retain, nonatomic) NSString      *g_strOSUserId;
@property (retain, nonatomic) NSArray       *g_aryEmojis;
@property (retain, nonatomic) NSArray       *g_aryInApps;
@property (retain, nonatomic) NSString      *g_strDeviceToken;
@property (retain, nonatomic) NSString      *g_strDeviceID;
@property (retain, nonatomic) NSNumber      *g_curTemperature;
@property (retain, nonatomic) NSData        *g_newDeviceToken;

@property (assign, nonatomic) BOOL          g_bShowFreeCoins;
@property (assign, nonatomic) BOOL          g_bVIPUser;


@end
