//
//  StoryObj.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/19/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryObj : NSObject

@property (retain, nonatomic) NSNumber  *story_id;
@property (retain, nonatomic) NSNumber  *story_location_id;
@property (retain, nonatomic) NSNumber  *story_user_id;
@property (retain, nonatomic) NSNumber  *story_qb_userid;
@property (retain, nonatomic) NSString  *story_os_userid;
@property (retain, nonatomic) NSString  *story_user_name;
@property (retain, nonatomic) NSNumber  *story_type;
@property (retain, nonatomic) NSString  *story_main_url;
@property (retain, nonatomic) NSString  *story_edit_url;
@property (retain, nonatomic) NSString  *story_tumb_url;
@property (retain, nonatomic) NSNumber  *story_is_approved;
@property (retain, nonatomic) NSNumber  *story_like_count;
@property (retain, nonatomic) NSNumber  *story_is_vip;
@property (retain, nonatomic) NSDate    *story_created;
@property (retain, nonatomic) NSNumber  *story_is_liked;

+ (StoryObj *) instanceWithDict:(NSDictionary *) dict;
- (NSDictionary *) currentDict;

@end
