//
//  CustomButton.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/13/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface CustomButton : UIButton

@property (nonatomic, assign) IBInspectable CGFloat  borderWidth;
@property (nonatomic, assign) IBInspectable CGFloat  cornerRadius;
@property (nonatomic, retain) IBInspectable UIColor  *borderColor;
@property (nonatomic, assign) IBInspectable BOOL     verticalAlign;

@end
