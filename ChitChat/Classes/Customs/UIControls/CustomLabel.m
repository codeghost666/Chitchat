//
//  CustomLabel.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/13/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (![self.attributeContentText isEqualToString:@""]) {
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self.text];
        NSRange range = [self.text rangeOfString:self.attributeContentText];
        
        UIFont *font = [UIFont fontWithName:self.attributeFontName size:self.attributeFontSize];
        
        if (![NSObject isValid:font]) {
        
            font = self.font;
        }
        
        [attString addAttributes:@{
                                   NSForegroundColorAttributeName   : self.attributeForegroundColor,
                                   NSFontAttributeName              : font
                                   }
                           range:range];

       self.attributedText = attString;
    }
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (!self) {
        
        return nil;
    }
    
    [self inspectableDefaults];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (!self) {
        return nil;
    }
    
    [self inspectableDefaults];
    
    return self;
}

- (void) inspectableDefaults {
    
    self.attributeContentText       = @"";
    self.attributeFontName          = self.font.fontName;
    self.attributeFontSize          = self.font.pointSize;
    self.attributeForegroundColor   = self.textColor;    
}

@end
