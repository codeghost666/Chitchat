//
//  CustomButton.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/13/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.cornerRadius = self.cornerRadius;
    
    [self setLayout];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    
    [super setTitle:title forState:state];
    [self setLayout];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    
    [super setImage:image forState:state];
    [self setLayout];
}

- (void)setLayout {
    
    if(self.verticalAlign) {
        
        CGSize imageSize = self.imageView.frame.size;
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0,
                                                - imageSize.width,
                                                - (imageSize.height + 6.f),
                                                0.0);
        
        // raise the image and push it right so it appears centered
        //  above the text
        CGSize titleSize = self.titleLabel.frame.size;
        self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + 6.f),
                                                0.0,
                                                0.0,
                                                - titleSize.width);
    }
}

@end
