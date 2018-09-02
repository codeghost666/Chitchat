//
//  CCTrendingTagAlertView.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/22/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VIP_COIN_COUNT                  90

@protocol CCTrendingTagAlertViewDelegate <NSObject>

- (void) didClickSubmit:(NSDictionary *) trending_tag;
- (void) didClickClose;

@end

@interface CCTrendingTagAlertView : CustomView {
    
    NSDictionary *trendig_tag;
}

@property (weak, nonatomic) IBOutlet UITableView *m_tblTrendingTag;

@property (retain, nonatomic) NSArray *trendingTags;

@property (retain, nonatomic) UIViewController *parentVC;

@property (assign, nonatomic) id<CCTrendingTagAlertViewDelegate> delegate;

- (IBAction)onClickSubmit:(id)sender;
- (IBAction)onClickClose:(id)sender;

@end
