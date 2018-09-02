//
//  CCNotificationTableViewCell.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/18/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCNotificationTableViewCell.h"

@implementation CCNotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) setNotificationObj:(NotificationObj *)notificationObj {
    
    _notificationObj = notificationObj;
    
    // set photo
    self.m_ivPhoto.borderWidth = 1.0f;
    self.m_ivPhoto.borderColor = [UIColor lightGrayColor];
    NSString *strURL = notificationObj.story_type.integerValue == StoryTypePhoto ? notificationObj.story_main_url : notificationObj.story_tumb_url;
    
    [self.m_ivPhoto sd_setImageWithURL:[NSURL URLWithString:strURL]
                      placeholderImage:[UIImage imageNamed:@"ic_user_avatar"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 
                                 self.m_ivPhoto.image = error ? [UIImage imageNamed:@"ic_user_avatar"] : image;
                             }];
    
    // set notification string
    NSRange range = [notificationObj.notification_string rangeOfString:@" liked "];
    if (NSNotFound == range.location) {
        
        self.m_lblNotification.text = notificationObj.notification_string;
    }
    else {
    
        NSString *strUserName = [notificationObj.notification_string substringToIndex:range.location];
        NSString *strNotification = [notificationObj.notification_string substringFromIndex:range.location];
        self.m_lblNotification.text = [NSString stringWithFormat:@"@%@%@", strUserName, strNotification];
        
        self.m_lblNotification.userInteractionEnabled = YES;
        PatternTapResponder userHandleTapAction = ^(NSString *tappedString){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SELECT_NOTIFICATION_USERNAME object:nil userInfo:@{@"user_qb_userid" : notificationObj.user_qb_userid, @"user_name" : [tappedString substringFromIndex:1]}];
        };
        
        [self.m_lblNotification enableUserHandleDetectionWithAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor], RLTapResponderAttributeName:userHandleTapAction}];
    }
    
    // set notification time
    NSString *strDate = [notificationObj.notification_created formattedDateWithFormat:@"M/dd" timeZone:ADJUST_TIMEZONE(@"UTC")];
    NSString *strToday = [[NSDate date] formattedDateWithFormat:@"M/dd" timeZone:ADJUST_TIMEZONE(@"UTC")];
    
    if ([strDate isEqualToString:strToday]) {
        
        NSDate *date = [notificationObj.notification_created dateToTimeZone:[NSTimeZone localTimeZone] fromTimeZone:ADJUST_TIMEZONE(@"UTC")];
        self.m_lblTime.text = [date formattedDateWithFormat:@"hh:mm a" timeZone:ADJUST_TIMEZONE(@"UTC")];
        
    }
    else {
        
        self.m_lblTime.text = strDate;
    }
}

@end
