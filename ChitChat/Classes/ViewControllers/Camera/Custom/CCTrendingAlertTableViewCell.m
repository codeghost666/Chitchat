//
//  CCTrendingAlertTableViewCell.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/22/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCTrendingAlertTableViewCell.h"

@implementation CCTrendingAlertTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTrendingTag:(NSDictionary *)trendingTag {
    
    _trendingTag = trendingTag;
    
    // set label
    self.m_lblTrendingTag.text = [NSString stringWithFormat:@"#%@", trendingTag.allKeys[0]];
    self.m_lblTrendingTag.textColor = [UIColor whiteColor];
}

- (void) selectCell:(BOOL) selected {
    
    self.m_lblTrendingTag.textColor = selected ? [@"#FDFF30" representedColor] : [UIColor whiteColor];
}


@end
