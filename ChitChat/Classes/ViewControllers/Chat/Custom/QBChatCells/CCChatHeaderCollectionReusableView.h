//
//  CCChatHeaderCollectionReusableView.h
//  ChitChat
//
//  Created by Jinjin Lee on 11/1/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCChatHeaderCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

+ (UINib *)nib;
+ (NSString *)cellReuseIdentifier;


@end
