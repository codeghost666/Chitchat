//
//  CustomLabel.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/13/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface CustomLabel : UILabel

@property (nonatomic, retain) IBInspectable UIColor     *attributeForegroundColor;
@property (nonatomic, retain) IBInspectable NSString    *attributeFontName;
@property (nonatomic, retain) IBInspectable NSString    *attributeContentText;
@property (nonatomic, assign) IBInspectable CGFloat     attributeFontSize;

@end
