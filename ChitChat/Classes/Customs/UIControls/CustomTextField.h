//
//  CustomTextField.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/13/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface CustomTextField : UITextField

IBInspectable typedef NS_ENUM(NSUInteger, CustomTextFieldStyle) {
    
    CustomTextFieldStyleDefault = 0,
    CustomTextFieldStyleEmail,
    CustomTextFieldStyleSecure,
};

@property (nonatomic, assign) IBInspectable CGFloat  borderWidth;
@property (nonatomic, assign) IBInspectable CGFloat  cornerRadius;
@property (nonatomic, retain) IBInspectable UIColor  *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat  leftPadding;
@property (nonatomic, retain) IBInspectable UIColor  *placeholderColor;
@property (nonatomic, assign) IBInspectable NSUInteger validSecureLength;            // default 0

// left image selector
@property (nonatomic, retain) IBInspectable NSString *leftImageName;
@property (nonatomic, assign) IBInspectable BOOL     hasLeftImage;
@property (nonatomic, assign) IBInspectable CGFloat  leftImageLeftInset;
@property (nonatomic, assign) IBInspectable CGFloat  leftImageTopInset;
@property (nonatomic, assign) IBInspectable CGFloat  leftImageRightInset;
@property (nonatomic, assign) IBInspectable CGFloat  leftImageBottomInset;

@property (nonatomic, assign) CustomTextFieldStyle  textFieldStyle;   // default CustomTextFieldStyleDefault

- (BOOL) isValidText;

@end
