//
//  WebService.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/12/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "WSConfig.h"

typedef void(^SuccessBlock)(id response);
typedef void(^FailureBlock)(NSString *error);
typedef void(^ProgressBlock)(float progress);

@interface WebService : NSObject

+ (id) sharedInstance;

- (void) signupWithUserObj:(UserObj *) userObj
                   Success:(SuccessBlock) success
                   Failure:(FailureBlock) failure;

- (void) signinWithUserName:(NSString *) user_name
                   Password:(NSString *) user_password
                   DeviceID:(NSString *) user_device_id
                DeviceToken:(NSString *) user_device_token
                   Latitude:(NSNumber *) user_lat
                  Longitude:(NSNumber *) user_long
                    Success:(SuccessBlock) success
                    Failure:(FailureBlock) failure;

- (void) changeUserGenderWithUserId:(NSNumber *) user_id
                             Gender:(NSNumber *) user_gender
                            Success:(SuccessBlock) success
                            Failure:(FailureBlock) failure;

- (void) regQBUserWithUserId:(NSNumber *) user_id
                    QBUserId:(NSNumber *) user_qb_userid
                     Success:(SuccessBlock) success
                     Failure:(FailureBlock) failure;

- (void) getNearBySearchWithUserId:(NSNumber *) user_id
                            Gender:(NSNumber *) user_gender
                          DeviceID:(NSString *) user_device_id
                       DeviceToken:(NSString *) user_device_token
                          Latitude:(NSNumber *) user_lat
                         Longitude:(NSNumber *) user_long
                           Success:(SuccessBlock) success
                           Failure:(FailureBlock) failure;

- (void) saveLocationWithUserId:(NSNumber *) user_id
                 LocationObject:(LocationObj *) locationObj
                        Success:(SuccessBlock) success
                        Failure:(FailureBlock) failure;

- (void) exploreLocationWithUserId:(NSNumber *) user_id
                            Gender:(NSNumber *) user_gender
                          Latitude:(NSNumber *) user_lat
                         Longitude:(NSNumber *) user_long
                           Success:(SuccessBlock) success
                           Failure:(FailureBlock) failure;


- (void) checkNotificationWithUserId:(NSNumber *) user_id
                             Success:(SuccessBlock) success
                             Failure:(FailureBlock) failure;

- (void) getNotificationsWithUserId:(NSNumber *) user_id
                            Success:(SuccessBlock) success
                            Failure:(FailureBlock) failure;

- (void) readNotificationWithNotificationIds:(NSString *) notification_ids
                                     Success:(SuccessBlock) success
                                     Failure:(FailureBlock) failure;

- (void) getWeatherDataWithUserLatitude:(NSNumber *) user_lat
                              Longitude:(NSNumber *) user_long
                                Success:(SuccessBlock) success
                                Failure:(FailureBlock) failure;

- (void) getVIPStoriesWithUserId:(NSNumber *) user_id
                         Success:(SuccessBlock) success
                         Failure:(FailureBlock) failure;

- (void) getStoriesWithUserId:(NSNumber *) user_id
                   LocationId:(NSNumber *) location_id
                      Success:(SuccessBlock) success
                      Failure:(FailureBlock) failure;

- (void) setLikeStoryWithStoryId:(NSNumber *) story_id
                          UserId:(NSNumber *) user_id
                        UserName:(NSString *) user_name
                         Success:(SuccessBlock) success
                         Failure:(FailureBlock) failure;

- (void) setReadStoryWithUserId:(NSNumber *) user_id
                     LocationId:(NSNumber *) location_id
                    LastStoryId:(NSNumber *) last_story_id
                        Success:(SuccessBlock) success
                        Failure:(FailureBlock) failure;

- (void) addStoryWithStoryObj:(StoryObj *) storyObj
                TrendingTagId:(NSNumber *) trending_tag_id
                    MainMedia:(NSData *) main_media
                    EditMedia:(NSData *) edit_media
                   ThumbMedia:(NSData *) thumbMedia
                     Progress:(ProgressBlock) progress
                      Success:(SuccessBlock) success
                      Failure:(FailureBlock) failure;

- (void) updateCoinWithUserId:(NSNumber *) user_id
                    CoinCount:(NSNumber *) user_coin_count
                   UpdateType:(NSNumber *) update_coin_type
                      Success:(SuccessBlock) success
                      Failure:(FailureBlock) failure;

- (void) buyCoinWithUserId:(NSNumber *) user_id
                 CoinCount:(NSNumber *) coin_count
                     Price:(NSNumber *) price
                   Success:(SuccessBlock) success
                   Failure:(FailureBlock) failure;

- (void) getInAppDataWithSuccess:(SuccessBlock) success
                         Failure:(FailureBlock) failure;

- (void) getEmojiListWithSuccess:(SuccessBlock) success
                         Failure:(FailureBlock) failure;

- (void) verifyReceiptWithReceiptData:(NSString *) receipt_data
                       ProductionMode:(NSNumber *) is_production
                           DeviceType:(NSNumber *) device_type
                              Success:(SuccessBlock) success
                              Failure:(FailureBlock) failure;

// -------------- QuickBlox Handler
- (void) signUpQBUserWithUserObj:(UserObj *) userObj
                         Success:(SuccessBlock) success
                         Failure:(FailureBlock) failure;

- (void) signInQBUserWithUserObj:(UserObj *) userObj
                         Success:(SuccessBlock) success
                         Failure:(FailureBlock) failure;

- (void) getQBChatDialogWithUserObj:(UserObj *) usrObj
                         QBUserName:(NSString *) user_name
                            Success:(SuccessBlock) success
                            Failure:(FailureBlock) failure;

- (void) getQBChatDialogWithUserObj:(UserObj *) userObj
                            Success:(SuccessBlock) success
                            Failure:(FailureBlock) failure;

// --------------- One Signal user
- (void) registerOneSignalUserWithUserId:(NSNumber *) user_id
                         OneSignalUserID:(NSString *) user_os_userid
                                 Success:(SuccessBlock) success
                                 Failure:(FailureBlock) failure;

// --------------- VIP User
- (void) updateVIPUserWithUserId:(NSNumber *) user_id
                             VIP:(NSNumber *) user_is_vip
                         Success:(SuccessBlock) success
                         Failure:(FailureBlock) failure;


@end
