//
//  NotificationObj.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/18/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "NotificationObj.h"

@implementation NotificationObj

- (id) init {

    if (self = [super init]) {
        
        self.notificaiton_id        = @0;
        self.notification_story_id  = @0;
        self.notification_user_id   = @0;;
        self.notification_string    = @"";
        self.notification_is_read   = @NO;
        self.notification_created   = [NSDate date];
        self.story_type             = @(StoryTypeNone);
        self.story_main_url         = @"";
        self.story_tumb_url         = @"";
        self.user_qb_userid         = @0;
    }
    
    return self;
}

+ (NotificationObj *) instanceWithDict:(NSDictionary *) dict {
    
    NotificationObj *notificationObj = [[NotificationObj alloc] init];
    
    if ([NSObject isValid:dict]) {
        
        // set notification id
        if ([NSObject isValid:dict[@"notification_id"]])
            notificationObj.notificaiton_id = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"notification_id");
        
        // set notification story id
        if ([NSObject isValid:dict[@"notification_story_id"]])
            notificationObj.notification_story_id = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"notification_story_id");
        
        // set notification user id
        if ([NSObject isValid:dict[@"notification_user_id"]])
            notificationObj.notification_user_id = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"notification_user_id");
        
        // set notification string
        if ([NSObject isValid:dict[@"notification_string"]])
            notificationObj.notification_string = dict[@"notification_string"];
        
        // set notification is read
        if ([NSObject isValid:dict[@"notification_is_read"]])
            notificationObj.notification_is_read = DICTIONARY_STRING_TO_BOOL_NUMBER(dict, @"notification_is_read");
        
        // set notification created
        if ([NSObject isValid:dict[@"notification_created"]]) {
            
            NSDate *date = [NSDate dateWithString:dict[@"notification_created"]
                                     formatString:FORMAT_DATETIME
                                         timeZone:ADJUST_TIMEZONE(@"UTC")];
            
            notificationObj.notification_created = [NSObject isValid:date] ? date : [NSDate date];

            
//            notificationObj.notification_created = [NSObject isValid:date] ? [date dateToTimeZone:[NSTimeZone localTimeZone] fromTimeZone:ADJUST_TIMEZONE(@"UTC")] : [NSDate date];
        }
        
        // set notification story type
        if ([NSObject isValid:dict[@"story_type"]])
            notificationObj.story_type = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"story_type");
        
        // set notification story main url
        if ([NSObject isValid:dict[@"story_main_url"]])
            notificationObj.story_main_url = dict[@"story_main_url"];
        
        // set notification story tumb url
        if ([NSObject isValid:dict[@"story_tumb_url"]])
            notificationObj.story_tumb_url = dict[@"story_tumb_url"];
        
        // set user qb userid
        if ([NSObject isValid:dict[@"user_qb_userid"]])
            notificationObj.user_qb_userid = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"user_qb_userid");
        
    }
    
    return notificationObj;
}

- (NSDictionary *) currentDict {
    
    return @{};
}

@end
