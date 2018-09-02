//
//  CCWatchViewController.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/19/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCBaseViewController.h"

@interface CCWatchViewController : CCBaseViewController<CTVideoViewOperationDelegate> {
    
    NSMutableArray  *m_aryStories;
    
    NSTimer         *m_timerWatch;
    
    NSInteger       m_nWatchedStoryCount;
    
    ReadTuturialFlagType m_nReadTutorFlag;
}

@property (weak, nonatomic) IBOutlet UIImageView *m_ivPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivEdit;

@property (weak, nonatomic) IBOutlet UIView *m_vwOperation;
@property (weak, nonatomic) IBOutlet MDRadialProgressView *m_vwTimer;
@property (weak, nonatomic) IBOutlet UIButton *m_btnLike;
@property (weak, nonatomic) IBOutlet UILabel *m_lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTimeAgo;



@property (weak, nonatomic) IBOutlet UIView *m_vwEnd;
@property (weak, nonatomic) IBOutlet UILabel *m_lblEnd;
@property (weak, nonatomic) IBOutlet UIButton *m_btnReplayStories;

@property (weak, nonatomic) IBOutlet UIButton *m_btnCamera;

@property (weak, nonatomic) IBOutlet UIImageView *m_ivTutorial;

@property (retain, nonatomic) CTVideoView *m_vwVideo;
@property (retain, nonatomic) LocationObj *m_locationObj;


- (IBAction)onClickFlag:(id)sender;
- (IBAction)onClickChat:(id)sender;
- (IBAction)onClickLike:(id)sender;
- (IBAction)onClickReplay:(id)sender;
- (IBAction)onClickAddStory:(id)sender;
- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickCamera:(id)sender;
- (IBAction)onTapTutorial:(id)sender;
- (IBAction)onTapOperation:(id)sender;
- (IBAction)onSwipeRight:(id)sender;
- (IBAction)onSwipeLeft:(id)sender;



@end
