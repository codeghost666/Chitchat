//
//  CCCameraViewController.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/20/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCBaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <SCRecorder/SCRecorder.h>

typedef NS_ENUM(NSUInteger, CameraPosition) {

    CameraPositionBack = 0,
    CameraPositionFront,
};

typedef NS_ENUM(NSUInteger, CaptureType) {
    
    CaptureTypePhoto = 0,
    CaptureTypeVideo,
};

@interface CCCameraViewController : CCBaseViewController<SCRecorderDelegate> {
    
    SCRecorder          *m_scRecorder;
    SCRecordSession     *m_recordSession;
    ALAssetsLibrary     *m_assetsLib;
    CGPoint             m_focusPoint;
    BOOL                m_bSetFocus;
    
    CameraPosition      m_nCameraPosition;
    CaptureType         m_nCaptureType;
    
    ReadTuturialFlagType m_nReadTutorFlag;
    
    NSTimer             *m_timerShotHold;
}

@property (weak, nonatomic) IBOutlet UIView *m_vwPreview;
@property (weak, nonatomic) IBOutlet UIButton *m_btnFlash;
@property (weak, nonatomic) IBOutlet UIButton *m_btnCameraPosition;
@property (weak, nonatomic) IBOutlet MDRadialProgressView *m_vwShotProgress;
@property (weak, nonatomic) IBOutlet UIButton *m_btnShot;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivTutorial;

@property (strong, nonatomic) SCRecorderToolsView *m_focusView;

- (IBAction)onClickFlash:(id)sender;
- (IBAction)onClickCameraPosition:(id)sender;
- (IBAction)onClickBack:(id)sender;
- (IBAction)onTapTutorImage:(id)sender;
- (IBAction)onSwipeRight:(id)sender;
- (IBAction)onTouchDownShot:(id)sender;
- (IBAction)onTouchUpShot:(id)sender;

@end
