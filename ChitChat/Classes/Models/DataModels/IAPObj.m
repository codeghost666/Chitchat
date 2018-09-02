//
//  IAPObj.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/21/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "IAPObj.h"

@implementation IAPObj

- (id) init {
    
    if (self = [super init]) {
    
        self.inapp_id           = @0;
        self.inapp_coins        = @0;
        self.inapp_price        = @0.0f;
        self.inapp_code_android = @"";
        self.inapp_code_ios     = @"";
        self.inapp_icons        = @"";
        self.inapp_auto_renewal = @NO;
        self.inapp_created      = [NSDate date];
        self.inapp_product      = nil;
    }
    
    return self;
}

+ (IAPObj *) instanceWithDict:(NSDictionary *)dict {
    
    IAPObj *iapObj = [[IAPObj alloc] init];
    
    if ([NSObject isValid:dict]) {
        
        // set id
        if ([NSObject isValid:dict[@"inapp_id"]])
            iapObj.inapp_id = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"inapp_id");
        
        // set coins
        if ([NSObject isValid:dict[@"inapp_coins"]])
            iapObj.inapp_coins = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"inapp_coins");
        
        // set price
        if ([NSObject isValid:dict[@"inapp_price"]])
            iapObj.inapp_price = DICTIONARY_STRING_TO_FLOAT_NUMBER(dict, @"inapp_price");
        
        // set code android
        if ([NSObject isValid:dict[@"inapp_code_android"]])
            iapObj.inapp_code_android = dict[@"inapp_code_android"];
        
        // set code ios
        if ([NSObject isValid:dict[@"inapp_code_ios"]])
            iapObj.inapp_code_ios = dict[@"inapp_code_ios"];
        
        // set icons
        if ([NSObject isValid:dict[@"inapp_icons"]])
            iapObj.inapp_icons = dict[@"inapp_icons"];
        
        // set auto renewal
        if ([NSObject isValid:dict[@"inapp_auto_renewal"]])
            iapObj.inapp_auto_renewal = DICTIONARY_STRING_TO_BOOL_NUMBER(dict, @"inapp_auto_renewal");
        
        // set created
        if ([NSObject isValid:dict[@"inapp_created"]]) {
            
            NSDate *date = [NSDate dateWithString:dict[@"inapp_created"]
                                     formatString:FORMAT_DATETIME
                                         timeZone:ADJUST_TIMEZONE(@"UTC")];
            iapObj.inapp_created = [NSObject isValid:date] ? date : [NSDate date];
        }
    }
    
    return iapObj;
}

- (NSDictionary *) currentDict {
    
    return @{};
}

@end
