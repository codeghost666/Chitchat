//
//  WebService.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/12/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "WebService.h"

WebService *_sharedInstance = nil;
AFHTTPSessionManager *manager;

@implementation WebService

+ (id) sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"application/json", @"image/jpeg", @"image/png", @"video/mp4", nil];
    });
    
    return _sharedInstance;
}

- (void) signupWithUserObj:(UserObj *) userObj
                   Success:(SuccessBlock) success
                   Failure:(FailureBlock) failure {
    
    NSDictionary *param = @{
                            API_KEY_ACTION          : CHITCHAT_API_SIGNUP,
                            @"user_name"            : userObj.user_name,
                            @"user_password"        : userObj.user_password,
                            @"user_email"           : userObj.user_email,
                            @"user_gender"          : userObj.user_gender,
                            @"user_device_id"       : userObj.user_device_id,
                            @"user_device_token"    : userObj.user_device_token,
                            @"user_lat"             : userObj.user_lat,
                            @"user_long"            : userObj.user_long
                            };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 success ([UserObj instanceWithDict:dictResult[API_KEY_VALUES][@"user"]]);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

- (void) signinWithUserName:(NSString *) user_name
                   Password:(NSString *) user_password
                   DeviceID:(NSString *) user_device_id
                DeviceToken:(NSString *) user_device_token
                   Latitude:(NSNumber *) user_lat
                  Longitude:(NSNumber *) user_long
                    Success:(SuccessBlock) success
                    Failure:(FailureBlock) failure {
    
    NSDictionary *param = @{
                            API_KEY_ACTION          : CHITCHAT_API_SIGNIN,
                            @"user_name"            : user_name,
                            @"user_password"        : user_password,
                            @"user_device_id"       : user_device_id,
                            @"user_device_token"    : user_device_token,
                            @"user_lat"             : user_lat,
                            @"user_long"            : user_long
                            };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 success ([UserObj instanceWithDict:dictResult[API_KEY_VALUES][@"user"]]);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

- (void) changeUserGenderWithUserId:(NSNumber *) user_id
                             Gender:(NSNumber *) user_gender
                            Success:(SuccessBlock) success
                            Failure:(FailureBlock) failure {
    
    NSDictionary *param = @{
                            API_KEY_ACTION  : CHITCHAT_API_CHANGEUSERGENDER,
                            @"user_id"      : user_id,
                            @"user_gender"  : user_gender
                            };
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 success (dictResult[API_KEY_VALUES]);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

- (void) regQBUserWithUserId:(NSNumber *) user_id
                    QBUserId:(NSNumber *) user_qb_userid
                     Success:(SuccessBlock) success
                     Failure:(FailureBlock) failure {
    
    NSDictionary *param = @{
                            API_KEY_ACTION      : CHITCHAT_API_REGQBUSER,
                            @"user_id"          : user_id,
                            @"user_qb_userid"   : user_qb_userid
                            };
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 success (user_qb_userid);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

- (void) getNearBySearchWithUserId:(NSNumber *) user_id
                            Gender:(NSNumber *) user_gender
                          DeviceID:(NSString *) user_device_id
                       DeviceToken:(NSString *) user_device_token
                          Latitude:(NSNumber *) user_lat
                         Longitude:(NSNumber *) user_long
                           Success:(SuccessBlock) success
                           Failure:(FailureBlock) failure {
    
    NSDictionary *param = @{
                            API_KEY_ACTION          : CHITCHAT_API_GETNEARBYUSERGENDER,
                            @"user_id"              : user_id,
                            @"user_gender"          : user_gender,
                            @"user_device_id"       : user_device_id,
                            @"user_device_token"    : user_device_token,
                            @"user_lat"             : user_lat,
                            @"user_long"            : user_long
                            };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 success (dictResult[API_KEY_VALUES]);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}


- (void) saveLocationWithUserId:(NSNumber *) user_id
                 LocationObject:(LocationObj *) locationObj
                        Success:(SuccessBlock) success
                        Failure:(FailureBlock) failure {
    
    NSDictionary *param = @{
                            API_KEY_ACTION          : CHITCHAT_API_SAVELOCATION,
                            @"user_id"              : user_id,
                            @"location_place_id"    : locationObj.location_place_id,
                            @"location_name"        : locationObj.location_name,
                            @"location_lat"         : locationObj.location_lat,
                            @"location_long"        : locationObj.location_long,
                            @"location_type"        : locationObj.location_type
                            };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 success (dictResult[API_KEY_VALUES]);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

- (void) exploreLocationWithUserId:(NSNumber *) user_id
                            Gender:(NSNumber *) user_gender
                          Latitude:(NSNumber *) user_lat
                         Longitude:(NSNumber *) user_long
                           Success:(SuccessBlock) success
                           Failure:(FailureBlock) failure{
    
    NSDictionary *param = @{
                            API_KEY_ACTION    : CHITCHAT_API_EXPLORELOCATION,
                            @"user_id"        : user_id,
                            @"user_gender"    : user_gender,
                            @"user_lat"       : user_lat,
                            @"user_long"      : user_long
                            };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 NSMutableArray *aryData = [NSMutableArray new];
                 
                 for (NSDictionary * dict in dictResult[API_KEY_VALUES][@"location_list"]) {
                     
                     [aryData addObject:[LocationObj instanceWithDict:dict]];
                 }
                 
                 success ((NSArray *)aryData);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

- (void) checkNotificationWithUserId:(NSNumber *) user_id
                             Success:(SuccessBlock) success
                             Failure:(FailureBlock) failure{
    
    NSDictionary *param = @{
                            API_KEY_ACTION : CHITCHAT_API_CHECKNOTIFICATION,
                            @"user_id"     : user_id
                            };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 if ([NSObject isValid:dictResult[API_KEY_VALUES][@"noti_count"]]) {
                 
                     success (DICTIONARY_STRING_TO_INT_NUMBER(dictResult[API_KEY_VALUES], @"noti_count"));
                 }
                 else {
                     
                     success(@0);
                 }
                 
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

- (void) getNotificationsWithUserId:(NSNumber *) user_id
                            Success:(SuccessBlock) success
                            Failure:(FailureBlock) failure {
    
    NSDictionary *param = @{
                            API_KEY_ACTION  : CHITCHAT_API_GETNOTIFICATIONLIST,
                            @"user_id"      : user_id
                            };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 NSMutableArray *aryData = [NSMutableArray new];
                 
                 for (NSDictionary *dict in dictResult[API_KEY_VALUES][@"notification_list"]) {
                     
                     [aryData addObject:[NotificationObj instanceWithDict:dict]];
                 }
                 
                 success ((NSArray *) aryData);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

- (void) readNotificationWithNotificationIds:(NSString *) notification_ids
                                     Success:(SuccessBlock) success
                                     Failure:(FailureBlock) failure {
    
    NSDictionary *param = @{
                            API_KEY_ACTION          : CHITCHAT_API_READNOTIFICATION,
                            @"notification_id_list" : notification_ids
                            };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 success (dictResult[API_KEY_MESSAGE]);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

- (void) getWeatherDataWithUserLatitude:(NSNumber *) user_lat
                              Longitude:(NSNumber *) user_long
                                Success:(SuccessBlock) success
                                Failure:(FailureBlock) failure{
    
    NSDictionary *param = @{
                            @"lat"  : user_lat,
                            @"lon"  : user_long
                            };
    
    [manager GET:@"http://api.openweathermap.org/data/2.5/weather"
      parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // parse temperature (Absolute)
            float temperature = [responseObject[@"main"][@"temp"] floatValue];
            
            // change Celsius to Fahrenheit
            temperature = (9.0f / 5.0f) * (temperature - 273.15) + 32.0f;
            
            success(@((int)roundf(temperature)));
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failure (NETWORK_ISSUE);
        }];
}

- (void) getVIPStoriesWithUserId:(NSNumber *) user_id
                         Success:(SuccessBlock) success
                         Failure:(FailureBlock) failure {
    
    NSDictionary *param = @{
                            API_KEY_ACTION  : CHITCHAT_API_GETVIPSTORY,
                            @"user_id"      : user_id
                            };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 NSMutableArray *aryData = [NSMutableArray new];
                 for (NSDictionary *dict in dictResult[API_KEY_VALUES][@"story_list"]) {
                     
                     [aryData addObject:[StoryObj instanceWithDict:dict]];
                 }
                 
                 success ((NSArray *) aryData);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

- (void) getStoriesWithUserId:(NSNumber *) user_id
                   LocationId:(NSNumber *) location_id
                      Success:(SuccessBlock) success
                      Failure:(FailureBlock) failure {
    
    NSDictionary* param = @{
                            API_KEY_ACTION : CHITCHAT_API_GETSTORY,
                            @"user_id"     : user_id.stringValue,
                            @"location_id" : location_id.stringValue
                            };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 NSMutableArray *aryData = [NSMutableArray new];
                 for (NSDictionary *dict in dictResult[API_KEY_VALUES][@"story_list"]) {
                     
                     [aryData addObject:[StoryObj instanceWithDict:dict]];
                 }
                 
                 success ((NSArray *) aryData);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

- (void) setLikeStoryWithStoryId:(NSNumber *) story_id
                          UserId:(NSNumber *) user_id
                        UserName:(NSString *) user_name
                         Success:(SuccessBlock) success
                         Failure:(FailureBlock) failure {
    
    NSDictionary *param = @{
                            API_KEY_ACTION : CHITCHAT_API_SETLIKESTORY,
                            @"user_id"     : user_id,
                            @"story_id"    : story_id,
                            @"user_name"   : user_name
                            };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 success (dictResult[API_KEY_VALUES]);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

- (void) setReadStoryWithUserId:(NSNumber *) user_id
                     LocationId:(NSNumber *) location_id
                    LastStoryId:(NSNumber *) last_story_id
                        Success:(SuccessBlock) success
                        Failure:(FailureBlock) failure {
    
    NSDictionary *param = @{
                            API_KEY_ACTION      : CHITCHAT_API_SETREADSTORY,
                            @"user_id"          : user_id,
                            @"location_id"      : location_id,
                            @"last_story_id"    : last_story_id
                            };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 success (dictResult[API_KEY_MESSAGE]);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

- (void) addStoryWithStoryObj:(StoryObj *) storyObj
                TrendingTagId:(NSNumber *) trending_tag_id
                    MainMedia:(NSData *) main_media
                    EditMedia:(NSData *) edit_media
                   ThumbMedia:(NSData *) thumbMedia
                     Progress:(ProgressBlock) progress
                      Success:(SuccessBlock) success
                      Failure:(FailureBlock) failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"story_user_id"         : storyObj.story_user_id,
                                                                                     @"story_location_id"     : storyObj.story_location_id,
                                                                                     @"story_type"            : storyObj.story_type,
                                                                                     @"story_main_url"        : storyObj.story_main_url,
                                                                                     @"story_edit_url"        : storyObj.story_edit_url,
                                                                                     @"story_tumb_url"        : storyObj.story_tumb_url,
                                                                                     @"story_is_vip"          : storyObj.story_is_vip,
                                                                                     }];
    if (trending_tag_id.integerValue > 0) {
        
        [params setObject:CHITCHAT_API_TRENDING_ADDSTORY forKey:API_KEY_ACTION];
        [params setObject:trending_tag_id forKey:@"trending_location_id"];
    }
    else {
        
        [params setObject:CHITCHAT_API_ADDSTORY forKey:API_KEY_ACTION];
    }
    
    [manager POST:BASE_URL
       parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
    if(main_media) {
        
        if (storyObj.story_type.integerValue == StoryTypePhoto) {
            
            [formData appendPartWithFileData:main_media
                                        name:@"story_main"
                                    fileName:@"story_main"
                                    mimeType:@"image/jpeg"];
        }
        else {
            
            [formData appendPartWithFileData:main_media
                                        name:@"story_main"
                                    fileName:@"story_main"
                                    mimeType:@"video/mp4"];
        }
    }
    
    if(edit_media) {
        
        [formData appendPartWithFileData:edit_media
                                    name:@"story_edit"
                                fileName:@"story_edit"
                                mimeType:@"image/png"];
    }
    
    if(thumbMedia) {
        
        [formData appendPartWithFileData:thumbMedia
                                    name:@"story_tumb"
                                fileName:@"story_tumb"
                                mimeType:@"image/jpeg"];
    }
}
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
             if(main_media || edit_media || thumbMedia) {
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     progress(uploadProgress.fractionCompleted);
                 });
             }
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 success (dictResult[API_KEY_MESSAGE]);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure(error.localizedDescription);
          }];
}

- (void) updateCoinWithUserId:(NSNumber *) user_id
                    CoinCount:(NSNumber *) user_coin_count
                   UpdateType:(NSNumber *) update_coin_type
                      Success:(SuccessBlock) success
                      Failure:(FailureBlock) failure {
    
    NSDictionary *param = @{
                            API_KEY_ACTION         : CHITCHAT_API_UPDATAECOINCOUNT,
                            @"user_id"             : user_id,
                            @"user_coin_count"     : user_coin_count,
                            @"type"                : update_coin_type
                            };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 success (dictResult[API_KEY_MESSAGE]);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

- (void) buyCoinWithUserId:(NSNumber *) user_id
                 CoinCount:(NSNumber *) coin_count
                     Price:(NSNumber *) price
                   Success:(SuccessBlock) success
                   Failure:(FailureBlock) failure {
    
    NSDictionary *param = @{
                            API_KEY_ACTION : CHITCHAT_API_BUYCOIN,
                            @"user_id"     : user_id,
                            @"coin_count"  : coin_count,
                            @"price"       : price
                            };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 success (dictResult[API_KEY_MESSAGE]);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

- (void) getInAppDataWithSuccess:(SuccessBlock) success
                         Failure:(FailureBlock) failure {
    
    NSDictionary *param = @{ API_KEY_ACTION : CHITCHAT_API_GETINAPPDATA };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 success (dictResult[API_KEY_VALUES]);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

- (void) getEmojiListWithSuccess:(SuccessBlock) success
                         Failure:(FailureBlock) failure {
    
    NSDictionary *param = @{
                            API_KEY_ACTION : CHITCHAT_API_GETEMOJILIST
                            };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 NSMutableArray *aryEmojis = [NSMutableArray new];
                 NSArray *aryData = dictResult[API_KEY_VALUES][@"emoji"];
                 
                 for (NSDictionary *dict in aryData) {
                     
                     [aryEmojis addObject:[EmojiObj instanceWithDict:dict]];
                 }
                 
                 success (aryEmojis);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

- (void) verifyReceiptWithReceiptData:(NSString *) receipt_data
                       ProductionMode:(NSNumber *) is_production
                           DeviceType:(NSNumber *) device_type
                              Success:(SuccessBlock) success
                              Failure:(FailureBlock) failure {
    
    NSDictionary *param = @{
                            API_KEY_ACTION      : CHITCHAT_API_VERIFYRECEIPT,
                            @"receipt_data"     : receipt_data,
                            @"is_production"    : is_production,
                            @"device_type"      : device_type,
                            @"share_secret"     : VIP_SHARE_SECRET
                            };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 NSArray *aryData = dictResult[API_KEY_VALUES][@"latest_receipt"];
                 
                 if ([NSObject isValid:aryData]) {
                 
                     success ([ReceiptObj instanceWithDict:aryData.lastObject]);
                 }
                 else {
                  
                     success ([ReceiptObj instanceWithDict:nil]);
                 }
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}


// -------------- QuickBlox Handler
- (void) signUpQBUserWithUserObj:(UserObj *) userObj
                         Success:(SuccessBlock) success
                         Failure:(FailureBlock) failure {
    
    QBUUser *newUser = [QBUUser user];
    newUser.login      = userObj.user_name;
    newUser.password   = QB_DEFAULT_PASSWORD;
    newUser.email      = userObj.user_email;
    
    
    [[QMServicesManager instance].authService signUpAndLoginWithUser:newUser
                                                          completion:^(QBResponse * _Nonnull response, QBUUser * _Nullable userProfile) {
                                                              
                                                              if (response.success) {
                                                                  
                                                                  [[QMServicesManager instance].chatService connectWithCompletionBlock:nil];
                                                                  
                                                                  [self regQBUserWithUserId:userObj.user_id
                                                                                   QBUserId:@(userProfile.ID)
                                                                                    Success:success
                                                                                    Failure:failure];
                                                                  
                                                              }
                                                              else {
                                                                  
                                                                  failure (response.error.description);
                                                              }
                                                          }];

}

- (void) signInQBUserWithUserObj:(UserObj *) userObj
                         Success:(SuccessBlock) success
                         Failure:(FailureBlock) failure {
    
    QBUUser *signinUser = [QBUUser user];
    signinUser.login    = userObj.user_name;
    signinUser.password = QB_DEFAULT_PASSWORD;
    
    [[QMServicesManager instance] logInWithUser:signinUser
                                     completion:^(BOOL successed, NSString * _Nullable errorMessage) {
                                         
                                         if (successed) {
                                             
                                             success (nil);
                                         }
                                         else {
                                             
                                             failure (errorMessage);
                                         }
                                     }];
}

- (void) getQBChatDialogWithUserObj:(UserObj *) userObj
                            Success:(SuccessBlock) success
                            Failure:(FailureBlock) failure {
    
    [self getQBChatDialogWithUserObj:userObj
                          QBUserName:nil
                             Success:success
                             Failure:failure];
}

- (void) getQBChatDialogWithUserObj:(UserObj *) userObj
                         QBUserName:(NSString *) user_name
                            Success:(SuccessBlock) success
                            Failure:(FailureBlock) failure {

    NSDictionary *extendRequest = @{@"type" : @(QBChatDialogTypePrivate).stringValue};
    
    if ([NSObject isValid:user_name] && user_name.length > 0) {
        
        extendRequest = @{
                          @"type" : @(QBChatDialogTypePrivate).stringValue,
                          @"name" : user_name
                          };
    }
    
    if ([QMServicesManager instance].isAuthorized) {
        
        [[QMServicesManager instance].chatService allDialogsWithPageLimit:QB_DIALOG_PAGELIMIT
                                                          extendedRequest:extendRequest
                                                           iterationBlock:^(QBResponse * _Nonnull response, NSArray<QBChatDialog *> * _Nullable dialogObjects, NSSet<NSNumber *> * _Nullable dialogsUsersIDs, BOOL * _Nonnull stop) {
                                                               
                                                               success(dialogObjects);
                                                               
                                                           } completion:^(QBResponse * _Nonnull response) {
                                                               
                                                               if (!response.success) failure (response.error.error.localizedDescription);
                                                           }];
        
    }
    else {
        
        [self signInQBUserWithUserObj:userObj
                              Success:^(id response) {
                                  
                                  [[QMServicesManager instance].chatService allDialogsWithPageLimit:QB_DIALOG_PAGELIMIT
                                                                                    extendedRequest:extendRequest
                                                                                     iterationBlock:^(QBResponse * _Nonnull response, NSArray<QBChatDialog *> * _Nullable dialogObjects, NSSet<NSNumber *> * _Nullable dialogsUsersIDs, BOOL * _Nonnull stop) {
                                                                                         
                                                                                         success(dialogObjects);
                                                                                         
                                                                                     } completion:^(QBResponse * _Nonnull response) {
                                                                                         
                                                                                         if (!response.success) failure (response.error.error.localizedDescription);
                                                                                     }];
                                  
                              } Failure:failure];
    }

}

- (void) registerOneSignalUserWithUserId:(NSNumber *) user_id
                         OneSignalUserID:(NSString *) user_os_userid
                                 Success:(SuccessBlock) success
                                 Failure:(FailureBlock) failure {
    
    NSDictionary *param = @{
                            API_KEY_ACTION      : CHITCHAT_API_REGOSUSER,
                            @"user_id"          : user_id,
                            @"user_os_userid"   : user_os_userid
                            };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {

                 success (dictResult[API_KEY_MESSAGE]);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

- (void) updateVIPUserWithUserId:(NSNumber *) user_id
                             VIP:(NSNumber *) user_is_vip
                         Success:(SuccessBlock) success
                         Failure:(FailureBlock) failure {
    
    NSDictionary *param = @{
                            API_KEY_ACTION   : CHITCHAT_API_UPDATEVIPUSER,
                            @"user_id"       : user_id,
                            @"user_is_vip"   : user_is_vip
                            };
    
    [manager POST:BASE_URL
       parameters:param
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dictResult = (NSDictionary *) responseObject;
             
             if ([dictResult[API_KEY_RESULT] isEqualToString:API_RESPONSE_SUCCESS]) {
                 
                 success (dictResult[API_KEY_MESSAGE]);
             }
             else {
                 
                 failure (dictResult[API_KEY_MESSAGE]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure (NETWORK_ISSUE);
         }];
}

@end
