//
//  CCEmojiCollectionViewCell.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/21/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCEmojiCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *m_ivEmoji;
@property (retain, nonatomic) EmojiObj *emojiObj;


@end
