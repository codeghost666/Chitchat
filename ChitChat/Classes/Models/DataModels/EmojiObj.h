//
//  EmojiObj.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/12/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmojiObj : NSObject

@property (retain, nonatomic) NSNumber  *emoji_id;
@property (retain, nonatomic) NSString  *emoji_img;
@property (retain, nonatomic) NSNumber  *emoji_coin;
@property (retain, nonatomic) NSDate    *emoji_created;

+ (EmojiObj *) instanceWithDict:(NSDictionary *) dict;


@end
