//
//  CCEmojiCollectionViewCell.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/21/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCEmojiCollectionViewCell.h"

@implementation CCEmojiCollectionViewCell

- (void) setEmojiObj:(EmojiObj *)emojiObj {
    
    // set emoji object
    _emojiObj = emojiObj;
    
    // set emoji image
    [self.m_ivEmoji sd_setImageWithURL:[NSURL URLWithString:emojiObj.emoji_img]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

                                 self.m_ivEmoji.image = image;
                             }];
}

@end
