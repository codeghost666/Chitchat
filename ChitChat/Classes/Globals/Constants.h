//
//  Constants.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/12/16.
//  Copyright © 2016 developer. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

// Define Macro
#define DICTIONARY_STRING_TO_BOOL_NUMBER(dict, key)      [NSNumber numberWithBool:[[dict valueForKey:key] boolValue]]
#define DICTIONARY_STRING_TO_INT_NUMBER(dict, key)       [NSNumber numberWithInteger:[[dict valueForKey:key] integerValue]]
#define DICTIONARY_STRING_TO_FLOAT_NUMBER(dict, key)     [NSNumber numberWithDouble:[[dict valueForKey:key] floatValue]]
#define DICTIONARY_STRING_TO_DOUBLE_NUMBER(dict, key)    [NSNumber numberWithDouble:[[dict valueForKey:key] doubleValue]]

#define DEVELOPMENT

// Define Date Format
#define FORMAT_DATETIME             @"yyyy-MM-dd HH:mm:ss"
#define FORMAT_DATE                 @"yyyy-MM-dd"
#define ADJUST_TIMEZONE(x)          [NSTimeZone timeZoneWithName:x]


// App Config Constants
#define APP_NAME                    @"ChitChat"
#define APP_KEY                     @"382ed005"

// QuickBlox Config Constants
#define QB_APP_ID                   48868
#define QB_AUTH_KEY                 @"7euzEYpEEUH5F6U"
#define QB_AUTH_SECRET              @"SFrxyAsgfRhc-BJ"
#define QB_ACCOUNT_KEY              @"VnFojvQpzx1LMu7xbkQP"
#define QB_DEFAULT_PASSWORD         @"123456789"
#define QB_DIALOG_PAGELIMIT         15


// Facebook Config Constants
#define FACEBOOK_APP_ID             @"753584404690735"

// Twitter Config Constants
#define TWITTER_KEY                 @"tzP40WHd9rRDLqP7R0sHrTpA6"
#define TWITTER_SECRET              @"n49ZDChpY4TMLnQgXJ4p2Z3qHYWTTln8oUaIbbW9fnHJtzzB4Q"

// Instagram Config Constants
#define INSTAGRAM_APP_ID            @"0f1783f0ff8348a5ad59ddcf78000fe9"
#define INSTAGRAM_CLIENT_ID         @"2a00f2423ef34869b995e8d8c4acf8f2"
#define INSTAGRAM_CLIENT_SECRET     @"07d12673312f4176bbef2d9aec5f9605"
#define INSTAGRAM_REDIRECT_URL      @"http://yourcallback.com/"

// Tumblr Config Constants
#define TUMBLR_CUSTOMER_KEY         @"NKtjj55jHEszwoBLttUw31Y1bqQoGsYNA01l3LexFv2WmoOA1s"
#define TUMBLR_CUSTOMER_SECRET      @"qt5coU6766uTqfYWJctxQ3zmygcVbTTp3lVkPFPQzJUU2pNpLo"
#define TUMBLR_OAUTH_TOKEN          @"qyoyMfsNWeWHEZGId9QLioBtiU4CHXwuZjwJvyCcrunj4REswN"
#define TUMBLR_OAUTH_TOKEN_SECRET   @"jRXTOlnaiVeEAZaW9H7eHmkiJnAfx1Ob2gG9rGHHOuwcKtIe4a"

// Trending Tag Key Constants
#define TRENDING_TAG_FEATURED       @"Featured"
#define TRENDING_TAG_SELFIES        @"Selfies"
#define TRENDING_TAG_SEXY           @"Sexy"
#define TRENDING_TAG_HOTRORNAH      @"HotrOrNah"
#define TRENDING_TAG_LETSCHAT       @"LetsChat"
#define TRENDING_TAG_ADDME          @"AddMe"
#define TRENDING_TAG_420            @"420"

// Define Config Key
#define CONFIG_KEY_USER                 @"user"
#define CONFIG_KEY_LOCATION             @"location"
#define CONFIG_KEY_SIGNIN               @"signin"
#define CONFIG_KEY_DEVICETOKEN          @"device_token"
#define CONFIG_KEY_READ_HOME_TUTOR      @"read_home_tutor"
#define CONFIG_KEY_READ_CAMERA_TUTOR    @"read_camera_tutor"
#define CONFIG_KEY_READ_WATCH_TUTOR     @"read_watch_tutor"
#define CONFIG_KEY_SHARE_PROMOTION      @"share_promotion"
#define CONFIG_KEY_CHECK_18_OLDS        @"check_olds"
#define CONFIG_KEY_ALREADY_SUBMITTED    @"already_submitted"
#define CONFIG_KEY_LAUNCHED             @"launched"
#define CONFIG_KEY_SUBSCRIPT_EXPIREDATE @"expire_date"


// Define ProgressHUD
#define SHOW_WAIT_MESSAGE              [SVProgressHUD showWithStatus:@"Please wait ..."]
#define SHOW_STATU_MESSAGE(status)     [SVProgressHUD showWithStatus:status]
#define SHOW_SUCCESS_MESSAGE(success)  [SVProgressHUD showSuccessWithStatus:success]
#define SHOW_INFO_MESSAGE(info)        [SVProgressHUD showInfoWithStatus:info]
#define SHOW_ERROR_MESSAGE(error)      [SVProgressHUD showErrorWithStatus:error]
#define DISMISS_MESSAGE                [SVProgressHUD dismiss]
#define NETWORK_ISSUE                  @"Please try again!"

// Define Notification Name
#define NOTI_GET_MY_LOCATION            @"NOTI_GET_MY_LOCATION"
#define NOTI_GET_UNREAD_NOTIFICATIONS   @"NOTI_GET_UNREAD_NOTIFICATIONS"
#define NOTI_SHOW_NEXT_STORY            @"NOTI_SHOW_NEXT_STORY"
#define NOTI_CHANGE_TITLE               @"NOTI_CHANGE_TITLE"
#define NOTI_CONNECT_CHAT               @"NOTI_CONNECT_CHAT"
#define NOTI_RESET_CAMERA               @"NOTI_RESET_CAMERA"
#define NOTI_SELECT_NOTIFICATION_USERNAME   @"NOTI_SELECT_NOTIFICATION_USERNAME"
#define NOTI_DID_RECEIVE_NEW_CHAT       @"NOTI_DID_RECEIVE_NEW_CHAT"

// Define Auto Renewal Share Secret
#define VIP_SHARE_SECRET                @"be35d1593c4945c5ad10d514fa570656"

// Define One Signal APP ID
#define ONESIGNAL_APP_ID                @"b3667f51-8274-4b82-81b0-7d05844ab702"

// Define MAT Informations
#define MAT_ADVERTISER_ID               @"15710"
#define MAT_CONVERSION_KEY              @"adeca592aaec72c1a79842c7639e8599"

// Define Terms URL
#define TERMS_URL                           [NSURL URLWithString:@"http://chitchatapp.co/terms"]


// Define Acceptable Characters for User Name
#define ACCEPTABLE_USERNAME_CHARACTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"

// Define User Type
typedef NS_ENUM(NSUInteger, UserGender) {
    
    UserGenderMale = 0,
    UserGenderFemale,
};

// Define Location Type
typedef NS_ENUM(NSUInteger, LocationType) {
    
    LocationTypeNone    = 0,
    LocationTypeCollege = 2,
    LocationTypeCity    = 3,
};

// Define Read Tutorial Flag Type
typedef NS_ENUM(NSUInteger, ReadTuturialFlagType) {
    
    ReadTuturialFlagTypeNone = 0,
    ReadTuturialFlagTypeHome1st,
    ReadTuturialFlagTypeHome2nd,
    ReadTuturialFlagTypeHome3rd,
    ReadTuturialFlagTypeCamera,
    ReadTuturialFlagTypeWatch1st,
    ReadTuturialFlagTypeWatch2nd,
};

// Define Story Type
typedef NS_ENUM(NSUInteger, StoryType) {
    
    StoryTypeNone = 0,
    StoryTypePhoto,
    StoryTypeVideo,
};

// Define Update coin count type
typedef NS_ENUM(NSUInteger, UpdateCoinCountType) {
    
    UpdateCoinCountTypeInc = 1,
    UpdateCoinCountTypeDec = 2,
};





#endif /* Constants_h */
