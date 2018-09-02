//
//  CCTrendingAlertTableViewCell.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/22/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCTrendingAlertTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *m_lblTrendingTag;
@property (retain, nonatomic) NSDictionary *trendingTag;

- (void) selectCell:(BOOL) selected;

@end
