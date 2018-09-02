//
//  CCChatTextCell.h
//  ChitChat
//
//  Created by Jinjin Lee on 11/1/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <QMChatViewController/QMChatViewController.h>
#import "CCChatCellConfig.h"

@interface CCChatTextCell : QMChatCell

@property (weak, nonatomic) IBOutlet UIView *senderMark;
@property (assign, nonatomic) ChatSenderType senderType;

@end
