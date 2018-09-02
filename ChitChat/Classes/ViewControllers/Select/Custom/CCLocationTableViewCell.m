//
//  CCLocationTableViewCell.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/15/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCLocationTableViewCell.h"

@implementation CCLocationTableViewCell

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
    
    // set label
    self.textLabel.text = locationObj.location_name;
    
    // set selected background view
    UIView *view = [[UIView alloc] initWithFrame:self.frame];
    [view setBackgroundColor:[@"#FFFFFF3F" representedColor]];
    self.selectedBackgroundView = view;
}

@end
