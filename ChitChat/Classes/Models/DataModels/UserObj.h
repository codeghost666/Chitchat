//
//  UserObj.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/12/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObj : NSObject

@property (retain, nonatomic) NSNumber *user_id;
@property (retain, nonatomic) NSString *user_name;
@property (retain, nonatomic) NSString *user_password;
@property (retain, nonatomic) NSString *user_email;
@property (retain, nonatomic) NSNumber *user_gender;
@property (retain, nonatomic) NSString *user_device_id;
@property (retain, nonatomic) NSString *user_device_token;
@property (retain, nonatomic) NSNumber *user_lat;
@property (retain, nonatomic) NSNumber *user_long;
@property (retain, nonatomic) NSNumber *user_star_count;
@property (retain, nonatomic) NSNumber *user_coin_count;
@property (retain, nonatomic) NSDate   *user_created;
@property (retain, nonatomic) NSNumber *user_qb_userid;
@property (retain, nonatomic) NSString *user_os_userid;
@property (retain, nonatomic) NSNumber *user_is_active;

+ (UserObj *) instanceWithDict:(NSDictionary *) dict;
- (NSDictionary *) currentDict;

@end
