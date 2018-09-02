//
//  LocationObj.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/17/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationObj : NSObject

@property (retain, nonatomic) NSNumber  *location_id;
@property (retain, nonatomic) NSString  *location_place_id;
@property (retain, nonatomic) NSString  *location_name;
@property (retain, nonatomic) NSNumber  *location_type;
@property (retain, nonatomic) NSNumber  *location_lat;
@property (retain, nonatomic) NSNumber  *location_long;
@property (retain, nonatomic) NSNumber  *location_story_count;
@property (retain, nonatomic) NSNumber  *location_is_featured;
@property (retain, nonatomic) NSDate    *location_created;

+ (LocationObj *) instanceWithDict:(NSDictionary *) dict;
- (NSDictionary *) currentDict;

@end
