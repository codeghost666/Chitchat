//
//  IAPObj.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/21/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAPObj : NSObject

@property (retain, nonatomic) NSNumber *inapp_id;
@property (retain, nonatomic) NSNumber *inapp_coins;
@property (retain, nonatomic) NSNumber *inapp_price;
@property (retain, nonatomic) NSString *inapp_code_android;
@property (retain, nonatomic) NSString *inapp_code_ios;
@property (retain, nonatomic) NSString *inapp_icons;
@property (retain, nonatomic) NSNumber *inapp_auto_renewal;
@property (retain, nonatomic) NSDate   *inapp_created;

@property (retain, nonatomic) SKProduct *inapp_product;
@property (retain, nonatomic) NSNumber *inapp_save_value;

+ (IAPObj *) instanceWithDict:(NSDictionary *) dict;
- (NSDictionary *) currentDict;


@end
