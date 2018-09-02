//
//  WSConfig.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/12/16.
//  Copyright © 2016 developer. All rights reserved.
//

#ifndef WSConfig_h
#define WSConfig_h

#define SERVER_ADDRESS                     @"52.10.49.5"
#define BASE_URL                           [NSString stringWithFormat:@"http://%@/app/index.php", SERVER_ADDRESS]

// Define API Name
#define CHITCHAT_API_SIGNUP                 @"signup"
#define CHITCHAT_API_SIGNIN                 @"signin"
#define CHITCHAT_API_CHANGEUSERGENDER       @"changeUserGender"
#define CHITCHAT_API_REGQBUSER              @"regQBUser"
#define CHITCHAT_API_REGOSUSER              @"regOSUser"
#define CHITCHAT_API_UPDATEVIPUSER          @"updateVIPUser"
#define CHITCHAT_API_GETNEARBYUSERGENDER    @"getNearByUserGender"
//#define CHITCHAT_API_GETNEARBYSEARCH        @"getNearByLocation"
#define CHITCHAT_API_SAVELOCATION           @"saveLocation"
#define CHITCHAT_API_ADDSTORY               @"addStory"
#define CHITCHAT_API_TRENDING_ADDSTORY      @"addStoryTrending"
#define CHITCHAT_API_SETLIKESTORY           @"setLikeStory"
#define CHITCHAT_API_GETSTORY               @"getStory"
#define CHITCHAT_API_GETEMOJILIST           @"getEmojiList"
#define CHITCHAT_API_VERIFYRECEIPT          @"verifyReceipt"
#define CHITCHAT_API_BUYCOIN                @"buyCoin"
#define CHITCHAT_API_UPDATAECOINCOUNT       @"updateCoinCount"
#define CHITCHAT_API_GETINAPPDATA           @"getInAppData"
//#define CHITCHAT_API_GETEXPLORELOCATION     @"getExplorerLocation"
#define CHITCHAT_API_EXPLORELOCATION        @"exploreLocation"
#define CHITCHAT_API_GETVIPSTORY            @"getVIPStory"
#define CHITCHAT_API_SETREADSTORY           @"setReadStory"
#define CHITCHAT_API_GETNOTIFICATIONLIST    @"getNotificationList"
#define CHITCHAT_API_DELETENOTIFICATION     @"deleteNotification"
#define CHITCHAT_API_READNOTIFICATION       @"readNotification"
#define CHITCHAT_API_CHECKNOTIFICATION      @"checkNotification"

// Define API Key
#define API_KEY_ACTION      @"action"
#define API_KEY_RESULT      @"result"
#define API_KEY_MESSAGE     @"message"
#define API_KEY_VALUES      @"values"

#define API_RESPONSE_SUCCESS    @"SUCCEED"
#define API_RESPONSE_FAILURE    @"FAILED"

#endif /* WSConfig_h */
