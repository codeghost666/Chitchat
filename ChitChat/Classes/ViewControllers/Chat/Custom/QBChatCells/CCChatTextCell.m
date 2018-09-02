//
//  CCChatTextCell.m
//  ChitChat
//
//  Created by Jinjin Lee on 11/1/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCChatTextCell.h"

@implementation CCChatTextCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.containerView.bgColor = [UIColor whiteColor];
}

+ (QMChatCellLayoutModel)layoutModel {
    
    QMChatCellLayoutModel defaultLayoutModel = [super layoutModel];
    defaultLayoutModel.containerInsets = UIEdgeInsetsMake(4, 15, 4, 4);
    
    return defaultLayoutModel;
}

- (void) setSenderType:(ChatSenderType)senderType {
    
    _senderType = senderType;
    
    switch (senderType) {
        case ChatSenderTypeMe:
            self.senderMark.backgroundColor = [@"#ff0486" representedColor];
            break;
            
        case ChatSenderTypeOther:
            self.senderMark.backgroundColor = [@"#047cff" representedColor];
            break;
            
        case ChatSenderTypeService:
            self.senderMark.backgroundColor = [@"#04ff7a" representedColor];
            break;
            
        default:
            break;
    }
}

@end
