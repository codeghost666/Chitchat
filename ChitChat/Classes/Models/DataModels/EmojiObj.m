//
//  EmojiObj.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/12/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "EmojiObj.h"

@implementation EmojiObj

- (id) init {

    if (self = [super init]) {
        
        self.emoji_id       = @0;
        self.emoji_img      = @"";
        self.emoji_coin     = @0;
        self.emoji_created  = [NSDate date];
    }
    
    return self;
}

+ (EmojiObj *) instanceWithDict:(NSDictionary *) dict {

    EmojiObj *emojiObj = [[EmojiObj alloc] init];
    
    if ([NSObject isValid:dict]) {
        
        // set emoji id
        if ([NSObject isValid:dict[@"emoji_id"]])
            emojiObj.emoji_id = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"emoji_id");
        
        // set emoji img
        if ([NSObject isValid:dict[@"emoji_img"]])
            emojiObj.emoji_img = dict[@"emoji_img"];
        
        // set emoji coin
        if ([NSObject isValid:dict[@"emoji_coin"]])
            emojiObj.emoji_coin = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"emoji_coin");
        
        // set emoji created
        if ([NSObject isValid:dict[@"emoji_created"]]) {
            
            NSDate *date = [NSDate dateWithString:dict[@"emoji_created"] formatString:FORMAT_DATETIME timeZone:ADJUST_TIMEZONE(@"UTC")];
            emojiObj.emoji_created = [NSObject isValid:date] ? date : [NSDate date];
        }
    }
    
    return emojiObj;
}


@end
