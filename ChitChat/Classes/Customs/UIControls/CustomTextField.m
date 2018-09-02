//
//  CustomTextField.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/13/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
 
    // set let padding
    if (self.hasLeftImage) {

        UIImageView *ivLeftPadding = [[UIImageView alloc] initWithFrame:CGRectMake(self.leftImageLeftInset, self.leftImageTopInset, self.leftPadding, CGRectGetHeight(self.frame) - self.leftImageTopInset)];
        ivLeftPadding.contentMode = UIViewContentModeScaleAspectFit;
        ivLeftPadding.image = [UIImage imageNamed:self.leftImageName];
        self.leftView = ivLeftPadding;
    }
    else {
        
        UIView *viewLeftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.leftPadding, 20)];
        self.leftView = viewLeftPadding;
    }
    self.leftViewMode = UITextFieldViewModeAlways;
    
    // set corner radius and border
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.cornerRadius = self.cornerRadius;
    
    // set placeholder color
    [self setValue:self.placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
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
    
    self.borderWidth        = 0.0f;
    self.cornerRadius       = 0.0f;
    self.borderColor        = [UIColor clearColor];
    self.leftPadding        = 15.0f;
    self.textFieldStyle     = CustomTextFieldStyleDefault;
    self.validSecureLength  = 0;
    self.placeholderColor   = [UIColor colorWithRed:199.f/255.f green:199.f/255.f blue:205.f/255.f alpha:1.f];
}

- (BOOL) isValidText {
    
    if ([self.text isEqualToString:@""])  return NO;
    
    BOOL result = YES;
    
    switch (self.textFieldStyle) {
            
        case CustomTextFieldStyleDefault:
            break;
            
        case CustomTextFieldStyleEmail:
            result = [self isValidEmail];
            break;
            
        case CustomTextFieldStyleSecure: {
            
            if (self.validSecureLength > 0) {
                
                result = self.text.length >= self.validSecureLength;
            }
        }
            break;
            
        default:
            break;
    }
    
    return result;
}

- (BOOL) isValidEmail {
    
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self.text];
}

- (void) setTextFieldStyle:(CustomTextFieldStyle)textFieldStyle {
    
    // set keyboard type based on textfield style
    if (textFieldStyle == CustomTextFieldStyleEmail) {
        
        self.keyboardType = UIKeyboardTypeEmailAddress;
    }
    else if (textFieldStyle == CustomTextFieldStyleSecure) {
        
        self.secureTextEntry = YES;
    }
    
    _textFieldStyle = textFieldStyle;
}

@end
