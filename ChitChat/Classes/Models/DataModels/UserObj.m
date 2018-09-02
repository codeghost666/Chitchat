//
//  UserObj.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/12/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "UserObj.h"

@implementation UserObj

- (id) init {
    
    if (self = [super init]) {

        self.user_id            = @0;
        self.user_name          = @"";
        self.user_password      = @"";
        self.user_email         = @"";
        self.user_gender        = @(UserGenderMale);
        self.user_device_id     = @"";
        self.user_device_token  = @"";
        self.user_lat           = @0.0;
        self.user_long          = @0.0;
        self.user_star_count    = @0;
        self.user_coin_count    = @0;
        self.user_created       = [NSDate date];
        self.user_qb_userid     = @0;
        self.user_os_userid     = @"";
        self.user_is_active     = @YES;
    }
    
    return self;
}

+ (UserObj *) instanceWithDict:(NSDictionary *) dict {
    
    UserObj *userObj = [[UserObj alloc] init];
    
    if ([NSObject isValid:dict]) {
        
        // set user id
        if ([NSObject isValid:dict[@"user_id"]])
            userObj.user_id = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"user_id");
        
        // set user name
        if ([NSObject isValid:dict[@"user_name"]])
            userObj.user_name = dict[@"user_name"];
        
        // set user password
        if ([NSObject isValid:dict[@"user_password"]])
            userObj.user_password = dict[@"user_password"];
        
        // set user email
        if ([NSObject isValid:dict[@"user_email"]])
            userObj.user_email = dict[@"user_email"];
        
        // set user gender
        if ([NSObject isValid:dict[@"user_gender"]])
            userObj.user_gender = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"user_gender");
        
        // set user device id
        if ([NSObject isValid:dict[@"user_device_id"]])
            userObj.user_device_id = dict[@"user_device_id"];
        
        // set user device token
        if ([NSObject isValid:dict[@"user_device_token"]])
            userObj.user_device_token = dict[@"user_device_token"];
        
        // set user latitude
        if ([NSObject isValid:dict[@"user_lat"]])
            userObj.user_lat = DICTIONARY_STRING_TO_DOUBLE_NUMBER(dict, @"user_lat");
        
        // set user longitude
        if ([NSObject isValid:dict[@"user_long"]])
            userObj.user_long = DICTIONARY_STRING_TO_DOUBLE_NUMBER(dict, @"user_long");
        
        // set user star count
        if ([NSObject isValid:dict[@"user_star_count"]])
            userObj.user_star_count = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"user_star_count");
        
        // set user coin count
        if ([NSObject isValid:dict[@"user_coin_count"]])
            userObj.user_coin_count = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"user_coin_count");
        
        // set user created
        if ([NSObject isValid:dict[@"user_created"]]) {
            
            NSDate *date = [NSDate dateWithString:dict[@"user_created"] formatString:FORMAT_DATETIME timeZone:ADJUST_TIMEZONE(@"UTC")];
            userObj.user_created = [NSObject isValid:date] ? date : [NSDate date];
        }
        
        // set user has quickblox account
        if ([NSObject isValid:dict[@"user_qb_userid"]])
            userObj.user_qb_userid = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"user_qb_userid");
        
        // set one signal user id
        if ([NSObject isValid:dict[@"user_os_userid"]])
            userObj.user_os_userid = dict[@"user_os_userid"];
        
        // set user is active
        if ([NSObject isValid:dict[@"user_is_active"]])
            userObj.user_is_active = DICTIONARY_STRING_TO_BOOL_NUMBER(dict, @"user_is_active");
            
    }
    
    return userObj;
}

- (NSDictionary *) currentDict {
    
    return @{
             @"user_id"             : _user_id,
             @"user_name"           : _user_name,
             @"user_password"       : _user_password,
             @"user_email"          : _user_email,
             @"user_gender"         : _user_gender,
             @"user_device_id"      : _user_device_id,
             @"user_device_token"   : _user_device_token,
             @"user_lat"            : _user_lat,
             @"user_long"           : _user_long,
             @"user_start_count"    : _user_star_count,
             @"user_coin_count"     : _user_coin_count,
             @"user_created"        : [_user_created formattedDateWithFormat:FORMAT_DATETIME timeZone:ADJUST_TIMEZONE(@"UTC")],
             @"user_qb_userid"      : _user_qb_userid,
             @"user_os_userid"      : _user_os_userid,
             @"user_is_active"      : _user_is_active
             };
}

@end
