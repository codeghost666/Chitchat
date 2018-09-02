//
//  CCHomeViewController.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/17/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCBaseViewController.h"

@interface CCHomeViewController : CCBaseViewController {
    
    NSMutableArray *m_aryData;
    
    ReadTuturialFlagType m_nReadFlag;
}

@property (weak, nonatomic) IBOutlet UIButton *m_btnNotification;
@property (weak, nonatomic) IBOutlet UIButton *m_btnChat;
@property (weak, nonatomic) IBOutlet UITableView *m_tblStory;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivTutorial;


- (IBAction)onClickNotification:(id)sender;
- (IBAction)onClickChat:(id)sender;
- (IBAction)onClickCamera:(id)sender;
- (IBAction)onClickExplore:(id)sender;
- (IBAction)onClickSettings:(id)sender;

- (IBAction)onTapGesture:(id)sender;
- (IBAction)onSwipeRightGesture:(id)sender;
- (IBAction)onSwipeLeftGesture:(id)sender;

@end
