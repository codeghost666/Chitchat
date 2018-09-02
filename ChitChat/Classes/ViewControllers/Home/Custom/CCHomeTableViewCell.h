//
//  CCHomeTableViewCell.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/17/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCHomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *m_lblLocationName;
@property (weak, nonatomic) IBOutlet CustomView *m_vwStoryCount;
@property (weak, nonatomic) IBOutlet UILabel *m_lblStoryCount;

@property (retain, nonatomic) LocationObj *locationObj;

@end
