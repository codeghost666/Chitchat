//
//  NSObject+Custom.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/12/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "NSObject+Custom.h"

@implementation NSObject (Custom)

+ (BOOL) isValid:(NSObject *) object {
    
    return (object != nil && ![object isEqual:[NSNull null]]);
}

@end
