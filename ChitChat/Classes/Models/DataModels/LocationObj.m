//
//  LocationObj.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/17/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "LocationObj.h"

@implementation LocationObj

- (id) init {

    if (self = [super init]) {
        
        self.location_id            = @0;
        self.location_place_id      = @"";
        self.location_name          = @"";
        self.location_type          = @(LocationTypeNone);
        self.location_lat           = @0.0f;
        self.location_long          = @0.0f;
        self.location_story_count   = @0;
        self.location_is_featured   = @NO;
        self.location_created       = [NSDate date];
    }
    
    return self;
}

+ (LocationObj *) instanceWithDict:(NSDictionary *)dict {
    
    LocationObj *locationObj = [[LocationObj alloc] init];
    
    if ([NSObject isValid:dict]) {
        
        // set location id
        if ([NSObject isValid:dict[@"location_id"]])
            locationObj.location_id = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"location_id");
        
        // set location place id
        if ([NSObject isValid:dict[@"location_place_id"]])
            locationObj.location_place_id = dict[@"location_place_id"];
        
        // set location name
        if ([NSObject isValid:dict[@"location_name"]])
            locationObj.location_name = dict[@"location_name"];
        
        // set location type
        if ([NSObject isValid:dict[@"location_type"]])
            locationObj.location_type = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"location_type");
        
        // set location lat
        if ([NSObject isValid:dict[@"location_lat"]])
            locationObj.location_lat = DICTIONARY_STRING_TO_DOUBLE_NUMBER(dict, @"location_lat");
        
        // set location long
        if ([NSObject isValid:dict[@"location_long"]])
            locationObj.location_long = DICTIONARY_STRING_TO_DOUBLE_NUMBER(dict, @"location_long");
        
        // set location story count
        if ([NSObject isValid:dict[@"location_story_count"]])
            locationObj.location_story_count = DICTIONARY_STRING_TO_INT_NUMBER(dict, @"location_story_count");
        
        // set location is featured
        if ([NSObject isValid:dict[@"location_is_featured"]])
            locationObj.location_is_featured = DICTIONARY_STRING_TO_BOOL_NUMBER(dict, @"location_is_featured");
        
        // set location created
        if ([NSObject isValid:dict[@"location_created"]]) {
            
            NSDate *date = [NSDate dateWithString:dict[@"location_created"] formatString:FORMAT_DATETIME timeZone:ADJUST_TIMEZONE(@"UTC")];
            locationObj.location_created = [NSObject isValid:date] ? date : [NSDate date];
        }
    }
    
    return locationObj;
}

- (NSDictionary *) currentDict {

    return @{
             @"location_id"             : self.location_id,
             @"location_place_id"       : self.location_place_id,
             @"location_name"           : self.location_name,
             @"location_type"           : self.location_type,
             @"location_lat"            : self.location_lat,
             @"location_long"           : self.location_long,
             @"location_story_count"    : self.location_story_count,
             @"location_is_featured"    : self.location_is_featured,
             @"location_created"        : [self.location_created formattedDateWithFormat:FORMAT_DATETIME
                                                                                timeZone:ADJUST_TIMEZONE(@"UTC")]
             };
}

@end
