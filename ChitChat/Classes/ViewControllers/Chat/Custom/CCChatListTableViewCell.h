//
//  CCChatListTableViewCell.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/24/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCChatListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *m_lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblLastMessageDate;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivNotification;

@property (retain, nonatomic) QBChatDialog *chatDialog;

@end
