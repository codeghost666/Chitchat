//
//  NotificationObj.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/18/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationObj : NSObject

@property (retain, nonatomic) NSNumber *notificaiton_id;
@property (retain, nonatomic) NSNumber *notification_story_id;
@property (retain, nonatomic) NSNumber *notification_user_id;
@property (retain, nonatomic) NSString *notification_string;
@property (retain, nonatomic) NSNumber *notification_is_read;
@property (retain, nonatomic) NSDate   *notification_created;
@property (retain, nonatomic) NSNumber *story_type;
@property (retain, nonatomic) NSString *story_main_url;
@property (retain, nonatomic) NSString *story_tumb_url;
@property (retain, nonatomic) NSNumber *user_qb_userid;

+ (NotificationObj *) instanceWithDict:(NSDictionary *) dict;
- (NSDictionary *) currentDict;

@end
