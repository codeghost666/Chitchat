//
//  ReceiptObj.m
//  ChitChat
//
//  Created by Jinjin Lee on 11/2/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "ReceiptObj.h"

@implementation ReceiptObj

- (id) init {

    if (self=[super init]) {
        
        self.expires_date               = [NSDate date];
        self.expires_date_ms            = @0;
        self.expires_date_pst           = [NSDate date];
        self.is_trial_period            = @NO;
        self.original_purchase_date     = [NSDate date];
        self.original_purchase_date_ms  = @0;
        self.original_purchase_date_pst = [NSDate date];
        self.original_transaction_id    = @"";
        self.product_id                 = @"";
        self.purchase_date              = [NSDate date];
        self.purchase_date_ms           = @0;
        self.purchase_date_pst          = [NSDate date];
        self.quantity                   = @0;
        self.transaction_id             = @"";
        self.web_order_line_item_id     = @"";
    }
    
    return self;
}

+ (instancetype) instanceWithDict:(NSDictionary *) dict {
    
    ReceiptObj *receiptObj = [[ReceiptObj alloc] init];
    
    if ([NSObject isValid:dict]) {
    
        // set expire date
        if ([NSObject isValid:dict[@"expires_date"]]) {
            
            NSDate *date = [NSDate dateWithString:dict[@"expires_date"] formatString:@"yyyy-MM-dd HH:mm:ss VV" timeZone:ADJUST_TIMEZONE(@"UTC")];
            receiptObj.expires_date = [NSObject isValid:date] ? date : [NSDate date];
        }
        
        // set expires_date_ms
        if ([NSObject isValid:dict[@"expires_date_ms"]])
            receiptObj.expires_date_ms = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"expires_date_ms");
        
        // set expires_date_pst
        if ([NSObject isValid:dict[@"expires_date_pst"]]) {
            
            NSDate *date = [NSDate dateWithString:dict[@"expires_date_pst"] formatString:@"yyyy-MM-dd HH:mm:ss VV" timeZone:ADJUST_TIMEZONE(@"UTC")];
            receiptObj.expires_date_pst = [NSObject isValid:date] ? date : [NSDate date];
        }
        
        // set is_trial_period
        if ([NSObject isValid:dict[@"is_trial_period"]])
            receiptObj.is_trial_period = DICTIONARY_STRING_TO_BOOL_NUMBER(dict, @"expires_date_pst");
        
        // set original_purchase_date
        if ([NSObject isValid:dict[@"original_purchase_date"]]) {
            
            NSDate *date = [NSDate dateWithString:dict[@"original_purchase_date"] formatString:@"yyyy-MM-dd HH:mm:ss VV" timeZone:ADJUST_TIMEZONE(@"UTC")];
            receiptObj.original_purchase_date = [NSObject isValid:date] ? date : [NSDate date];
        }
        
        // set original_purchase_date_ms
        if ([NSObject isValid:dict[@"original_purchase_date_ms"]])
            receiptObj.original_purchase_date_ms = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"original_purchase_date_ms");
        
        // set original_purchase_date_pst
        if ([NSObject isValid:dict[@"original_purchase_date_pst"]]) {
            
            NSDate *date = [NSDate dateWithString:dict[@"original_purchase_date_pst"] formatString:@"yyyy-MM-dd HH:mm:ss VV" timeZone:ADJUST_TIMEZONE(@"UTC")];
            receiptObj.original_purchase_date_pst = [NSObject isValid:date] ? date : [NSDate date];
        }
        
        // set original_transaction_id
        if ([NSObject isValid:dict[@"original_transaction_id"]])
            receiptObj.original_transaction_id = dict[@"original_transaction_id"];
        
        // set product_id
        if ([NSObject isValid:dict[@"product_id"]])
            receiptObj.product_id = dict[@"product_id"];
        
        // set purchase_date
        if ([NSObject isValid:dict[@"purchase_date"]]) {
            
            NSDate *date = [NSDate dateWithString:dict[@"purchase_date"] formatString:@"yyyy-MM-dd HH:mm:ss VV" timeZone:ADJUST_TIMEZONE(@"UTC")];
            receiptObj.purchase_date = [NSObject isValid:date] ? date : [NSDate date];
        }
        
        // set purchase_date_ms
        if ([NSObject isValid:dict[@"purchase_date_ms"]])
            receiptObj.purchase_date_ms = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"purchase_date_ms");
        
        // set purchase_date_pst
        if ([NSObject isValid:dict[@"purchase_date_pst"]]) {
            
            NSDate *date = [NSDate dateWithString:dict[@"purchase_date_pst"] formatString:@"yyyy-MM-dd HH:mm:ss VV" timeZone:ADJUST_TIMEZONE(@"UTC")];
            receiptObj.purchase_date_pst = [NSObject isValid:date] ? date : [NSDate date];
        }
        
        // set quantity
        if ([NSObject isValid:dict[@"quantity"]])
            receiptObj.quantity = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"quantity");
        
        // set transaction_id
        if ([NSObject isValid:dict[@"transaction_id"]])
            receiptObj.transaction_id = dict[@"transaction_id"];
        
        // set web_order_line_item_id
        if ([NSObject isValid:dict[@"web_order_line_item_id"]])
            receiptObj.web_order_line_item_id = dict[@"web_order_line_item_id"];
    }

    return receiptObj;
}

@end
