//
//  CCChatAttachmentCell.m
//  ChitChat
//
//  Created by Jinjin Lee on 11/1/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCChatAttachmentCell.h"

@interface CCChatAttachmentCell()

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end

@implementation CCChatAttachmentCell
@synthesize attachmentID = _attachmentID;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (QMChatCellLayoutModel)layoutModel {
    
    QMChatCellLayoutModel defaultLayoutModel = [super layoutModel];
    defaultLayoutModel.avatarSize = CGSizeMake(0, 0);
    defaultLayoutModel.containerInsets = UIEdgeInsetsMake(4, 4, 4, 15),
    defaultLayoutModel.topLabelHeight = 0;
    defaultLayoutModel.bottomLabelHeight = 14;
    
    return defaultLayoutModel;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.attachmentImageView.image = nil;
}

- (void)setAttachmentImage:(UIImage *)attachmentImage {
    
    self.progressLabel.hidden = YES;
    self.attachmentImageView.image = attachmentImage;
}

- (void)updateLoadingProgress:(CGFloat)progress {
    
    if (progress > 0.0) {
        self.progressLabel.hidden = NO;
    }
    
    self.progressLabel.text = [NSString stringWithFormat:@"%2.0f %%", progress * 100.0f];
}



@end
