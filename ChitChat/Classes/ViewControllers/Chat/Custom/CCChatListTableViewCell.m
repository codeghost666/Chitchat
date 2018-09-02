//
//  CCChatListTableViewCell.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/24/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCChatListTableViewCell.h"

@implementation CCChatListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setChatDialog:(QBChatDialog *)chatDialog {
    
    _chatDialog = chatDialog;
    
    // set user name
    self.m_lblUserName.text = [chatDialog.name stringByReplacingOccurrencesOfString:[GlobalData sharedInstance].g_selfUser.user_qb_userid.stringValue
                                                                         withString:@""];
    
    // set last message date
    NSString *lastDate = @"";
    
    if (chatDialog.lastMessageUserID == 0) {
        
        lastDate = @"opened";
        self.m_lblLastMessageDate.text = [NSString stringWithFormat:@"%@ %@", lastDate, [chatDialog.updatedAt timeAgoSinceNow]];
    }
    else if ([GlobalData sharedInstance].g_selfUser.user_qb_userid.integerValue == chatDialog.lastMessageUserID) {
        
        lastDate = @"delivered";
        self.m_lblLastMessageDate.text = [NSString stringWithFormat:@"%@ %@", lastDate, [chatDialog.lastMessageDate timeAgoSinceNow]];
    }
    else {
        
        lastDate = @"received";
        self.m_lblLastMessageDate.text = [NSString stringWithFormat:@"%@ %@", lastDate, [chatDialog.lastMessageDate timeAgoSinceNow]];
    }
    
    
    // set chat badge
    self.m_ivNotification.image = chatDialog.unreadMessagesCount > 0 ? [UIImage imageNamed:@"ic_arrow_filled"] : [UIImage imageNamed:@"ic_arrow_blank"];
}

@end
