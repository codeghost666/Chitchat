//
//  ReceiptObj.h
//  ChitChat
//
//  Created by Jinjin Lee on 11/2/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiptObj : NSObject

@property (retain, nonatomic) NSDate    *expires_date;
@property (retain, nonatomic) NSNumber  *expires_date_ms;
@property (retain, nonatomic) NSDate    *expires_date_pst;
@property (retain, nonatomic) NSNumber  *is_trial_period;
@property (retain, nonatomic) NSDate    *original_purchase_date;
@property (retain, nonatomic) NSNumber  *original_purchase_date_ms;
@property (retain, nonatomic) NSDate    *original_purchase_date_pst;
@property (retain, nonatomic) NSString  *original_transaction_id;
@property (retain, nonatomic) NSString  *product_id;
@property (retain, nonatomic) NSDate    *purchase_date;
@property (retain, nonatomic) NSNumber  *purchase_date_ms;
@property (retain, nonatomic) NSDate    *purchase_date_pst;
@property (retain, nonatomic) NSNumber  *quantity;
@property (retain, nonatomic) NSString  *transaction_id;
@property (retain, nonatomic) NSString  *web_order_line_item_id;

+ (instancetype) instanceWithDict:(NSDictionary *) dict;

@end
