//
//  CCNotificationTableViewCell.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/18/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCNotificationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet APAvatarImageView *m_ivPhoto;
@property (weak, nonatomic) IBOutlet ResponsiveLabel *m_lblNotification;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTime;

@property (retain, nonatomic) NotificationObj *notificationObj;

@end
