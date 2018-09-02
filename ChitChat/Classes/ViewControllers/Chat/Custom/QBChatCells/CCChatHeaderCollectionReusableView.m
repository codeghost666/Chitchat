//
//  CCChatHeaderCollectionReusableView.m
//  ChitChat
//
//  Created by Jinjin Lee on 11/1/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCChatHeaderCollectionReusableView.h"

@implementation CCChatHeaderCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (UINib *)nib {
    
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

+ (NSString *)cellReuseIdentifier {
    
    return NSStringFromClass([self class]);
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    layoutAttributes.transform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
    [super applyLayoutAttributes:layoutAttributes];
}

@end
