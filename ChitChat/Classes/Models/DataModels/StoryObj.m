//
//  StoryObj.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/19/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "StoryObj.h"

@implementation StoryObj

- (id) init {
    
    if (self = [super init]) {
    
        self.story_id           = @0;
        self.story_location_id  = @0;
        self.story_user_id      = @0;
        self.story_type         = @(StoryTypeNone);
        self.story_main_url     = @"";
        self.story_edit_url     = @"";
        self.story_tumb_url     = @"";
        self.story_is_approved  = @NO;
        self.story_like_count   = @0;
        self.story_is_vip       = @NO;
        self.story_created      = [NSDate date];
        self.story_is_liked     = @NO;
        self.story_qb_userid    = @0;
        self.story_os_userid    = @"";
        self.story_user_name    = @"";
    }
    
    return self;
}

+ (StoryObj *) instanceWithDict:(NSDictionary *)dict {
    
    StoryObj *storyObj = [[StoryObj alloc] init];
    
    if ([NSObject isValid:dict]) {
        
        // set story id
        if ([NSObject isValid:dict[@"story_id"]])
            storyObj.story_id = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"story_id");
        
        // set story location id
        if ([NSObject isValid:dict[@"story_location_id"]])
            storyObj.story_location_id = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"story_location_id");
        
        // set story user id
        if ([NSObject isValid:dict[@"story_user_id"]])
            storyObj.story_user_id = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"story_user_id");
        
        // set story type
        if ([NSObject isValid:dict[@"story_type"]])
            storyObj.story_type = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"story_type");
        
        // set story main url
        if ([NSObject isValid:dict[@"story_main_url"]])
            storyObj.story_main_url = dict[@"story_main_url"];
        
        // set story edit url
        if ([NSObject isValid:dict[@"story_edit_url"]])
            storyObj.story_edit_url = dict[@"story_edit_url"];
        
        // set story tumb url
        if ([NSObject isValid:dict[@"story_tumb_url"]])
            storyObj.story_tumb_url = dict[@"story_tumb_url"];
        
        // set story is approved
        if ([NSObject isValid:dict[@"story_is_approved"]])
            storyObj.story_is_approved = DICTIONARY_STRING_TO_BOOL_NUMBER(dict, @"story_is_approved");
        
        // set story like count
        if ([NSObject isValid:dict[@"story_like_count"]])
            storyObj.story_like_count = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"story_like_count");
        
        // set story is vip
        if ([NSObject isValid:dict[@"story_is_vip"]])
            storyObj.story_is_vip = DICTIONARY_STRING_TO_BOOL_NUMBER(dict, @"story_is_vip");
        
        // set story created
        if ([NSObject isValid:dict[@"story_created"]]) {
            
            NSDate *date = [NSDate dateWithString:dict[@"story_created"]
                                     formatString:FORMAT_DATETIME
                                         timeZone:ADJUST_TIMEZONE(@"UTC")];
            storyObj.story_created = [NSObject isValid:date] ? date : [NSDate date];
        }
        
        // set story is liked
        if ([NSObject isValid:dict[@"is_like"]])
            storyObj.story_is_liked = DICTIONARY_STRING_TO_BOOL_NUMBER(dict, @"is_like");
        
        // set story qb user id
        if ([NSObject isValid:dict[@"story_qb_userid"]])
            storyObj.story_qb_userid = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"story_qb_userid");
        
        // set story user name
        if ([NSObject isValid:dict[@"story_user_name"]])
            storyObj.story_user_name = dict[@"story_user_name"];
        
        // set story os user id
        if ([NSObject isValid:dict[@"user_os_userid"]])
            storyObj.story_os_userid = dict[@"user_os_userid"];
    }
    
    return storyObj;
}

- (NSDictionary *) currentDict {
    
    return @{};
}

@end
