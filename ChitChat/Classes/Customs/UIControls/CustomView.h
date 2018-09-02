//
//  CustomView.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/15/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface CustomView : UIView

@property (nonatomic, retain) IBInspectable UIColor      *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat      borderWidth;
@property (nonatomic, assign) IBInspectable CGFloat      cornerRadius;

@end
