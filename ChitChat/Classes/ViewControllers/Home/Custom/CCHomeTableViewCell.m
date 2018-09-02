//
//  CCHomeTableViewCell.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/17/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCHomeTableViewCell.h"

@implementation CCHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setLocationObj:(LocationObj *)locationObj {
    
    _locationObj = locationObj;
    
    // set location name
    self.m_lblLocationName.text = locationObj.location_name;
    
    // set story count
    self.m_vwStoryCount.hidden = locationObj.location_story_count.integerValue == 0;
    self.m_lblStoryCount.text = locationObj.location_story_count.stringValue;
    
    // set selected background view
    UIView *view = [[UIView alloc] initWithFrame:self.frame];
    [view setBackgroundColor:[@"#FFFFFF3F" representedColor]];
    self.selectedBackgroundView = view;
}

@end
