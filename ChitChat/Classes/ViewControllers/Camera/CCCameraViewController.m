//
//  CCCameraViewController.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/20/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCCameraViewController.h"
#import "SCRecordSessionManager.h"
#import "CCEditMediaViewController.h"

#define RECORD_PROGRESS_TOTAL       200
#define RECORD_PROGRESS_INTERVAL    0.05f


@interface CCCameraViewController ()

@end

@implementation CCCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViewController];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    [self resetCamera];
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [m_scRecorder stopRunning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [m_scRecorder previewViewFrameChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

# pragma mark - Event Handler

- (IBAction)onClickFlash:(id)sender {
    
    switch (m_scRecorder.flashMode) {
        case SCFlashModeOff:
            [self.m_btnFlash setSelected:YES];
            m_scRecorder.flashMode = SCFlashModeLight;
            break;
        case SCFlashModeLight:
            [self.m_btnFlash setSelected:NO];
            m_scRecorder.flashMode = SCFlashModeOff;
            break;
        default:
            break;
    }
    
    /*if ([m_scRecorder.captureSessionPreset isEqualToString:AVCaptureSessionPresetPhoto]) {
        switch (m_scRecorder.flashMode) {
            case SCFlashModeOff:
                [self.m_btnFlash setSelected:YES];
                m_scRecorder.flashMode = SCFlashModeLight;
                break;
            case SCFlashModeLight:
                [self.m_btnFlash setSelected:NO];
                m_scRecorder.flashMode = SCFlashModeOff;
                break;
            default:
                break;
        }
    }
    else {
        switch (m_scRecorder.flashMode) {
            case SCFlashModeOff:
                [self.m_btnFlash setSelected:YES];
                m_scRecorder.flashMode = SCFlashModeLight;
                break;
            case SCFlashModeLight:
                [self.m_btnFlash setSelected:NO];
                m_scRecorder.flashMode = SCFlashModeOff;
                break;
            default:
                break;
        }
    }*/
}

- (IBAction)onClickCameraPosition:(id)sender {
    
    m_nCameraPosition = m_nCameraPosition == CameraPositionBack ? CameraPositionFront : CameraPositionBack;
    m_scRecorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    [m_scRecorder switchCaptureDevices];
//    m_scRecorder.captureSessionPreset = AVCaptureSessionPresetPhoto;
}

- (IBAction)onClickBack:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onTapTutorImage:(id)sender {
    
    m_nReadTutorFlag = ReadTuturialFlagTypeCamera;
    
    [[NSUserDefaults standardUserDefaults] setInteger:m_nReadTutorFlag forKey:CONFIG_KEY_READ_CAMERA_TUTOR];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self setTutorImage];
}

- (IBAction)onSwipeRight:(id)sender {
    
    [self onClickBack:nil];
}

- (IBAction)onTouchDownShot:(id)sender {
    
    m_nCaptureType = CaptureTypePhoto;
    m_timerShotHold = [NSTimer scheduledTimerWithTimeInterval:0.7f target:self selector:@selector(prepareRecordVideo:) userInfo:nil repeats:NO];
}

- (IBAction)onTouchUpShot:(id)sender {
    
    if (m_nCaptureType == CaptureTypePhoto) {
        
        // stop hold timer
        if (m_timerShotHold) {
            
            [m_timerShotHold invalidate];
            m_timerShotHold = nil;
        }
        
        // take photo
        [self takePhoto];
    }
    else {
        
        // stop record video
        [self stopRecordVideo];
    }
}

- (void) prepareRecordVideo:(NSTimer *) timer {
    
    [timer invalidate];
    
    m_nCaptureType = CaptureTypeVideo;
    m_scRecorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    [self startRecordVideo];
}

- (void) takePhoto {
    
    m_focusPoint = CGPointMake(m_scRecorder.focusPointOfInterest.x, m_scRecorder.focusPointOfInterest.y);
    m_bSetFocus = YES;

    [m_scRecorder capturePhoto:^(NSError *error, UIImage *image) {
        
        if (image) {
            
            // go to edit view controller
            CCEditMediaViewController *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCEditMediaViewController"];
            
            StoryObj *storyObj = [[StoryObj alloc] init];
            storyObj.story_type = @(StoryTypePhoto);
            storyObj.story_user_id = [GlobalData sharedInstance].g_selfUser.user_id;
            storyObj.story_location_id = [GlobalData sharedInstance].g_selectedLocation.location_id;
            
            // rotate image
            image = [image rotateInDegrees:-90];
            
            // flipped image when front camera
            if (m_nCameraPosition == CameraPositionFront) {
                
                image = [image horizontalFlip];
            }
            editVC.m_imgBackground = image;
            
            editVC.m_storyObj = storyObj;
            [self.navigationController pushViewController:editVC animated:YES];
        }
        else {
            
            NSString *strError = [NSString stringWithFormat:@"Cannot take photo!\n%@", error.localizedDescription];
            SHOW_ERROR_MESSAGE(strError);
        }
    }];
}

- (void) startRecordVideo {
    
    [m_scRecorder record];
}

- (void) stopRecordVideo {
    
    [m_scRecorder pause:^{
        
        [self saveVideoWithSession:m_scRecorder.session];
    }];

}

- (void) saveVideoWithSession:(SCRecordSession *) recordSession {
    
    
    [recordSession mergeSegmentsUsingPreset:AVAssetExportPresetHighestQuality completionHandler:^(NSURL *url, NSError *error) {
        
        if (error == nil) {
            
            // go to edit view controller
            CCEditMediaViewController *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCEditMediaViewController"];
            
            StoryObj *storyObj = [[StoryObj alloc] init];
            storyObj.story_type = @(StoryTypeVideo);
            storyObj.story_user_id = [GlobalData sharedInstance].g_selfUser.user_id;
            storyObj.story_location_id = [GlobalData sharedInstance].g_selectedLocation.location_id;
            storyObj.story_main_url = [url absoluteString];
            editVC.m_storyObj = storyObj;
            
            [self.navigationController pushViewController:editVC animated:YES];
            
            [self resetVideo];

        } else {
            
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Cannot save video to library!\n%@", error.localizedDescription]];
        }
    }];
}

- (void) resetVideo {
    
    SCRecordSession *recordSession = m_scRecorder.session;
    
    if (recordSession != nil) {
        m_scRecorder.session = nil;
        
        // If the recordSession was saved, we don't want to completely destroy it
        if ([[SCRecordSessionManager sharedInstance] isSaved:recordSession]) {
            [recordSession endSegmentWithInfo:nil completionHandler:nil];
        } else {
            [recordSession cancelSession:nil];
        }
    }
}


# pragma mark - Initialize Handler

- (void) initViewController {
    
    // init variables
    self.m_btnFlash.selected = NO;
    m_nCaptureType = CaptureTypePhoto;
    m_nCameraPosition = CameraPositionBack;
    m_focusPoint = CGPointMake(-1.0f, -1.0f);
    
    // init shot button view
    MDRadialProgressTheme *newTheme = [[MDRadialProgressTheme alloc] init];
    newTheme.thickness = 10.0f;
    newTheme.completedColor = [UIColor whiteColor];
    newTheme.incompletedColor = [UIColor whiteColor];
    newTheme.centerColor = [UIColor clearColor];
    newTheme.sliceDividerHidden = YES;
    
    self.m_vwShotProgress.theme = newTheme;
    self.m_vwShotProgress.progressTotal = RECORD_PROGRESS_TOTAL;
    self.m_vwShotProgress.progressCounter = 1;
    self.m_vwShotProgress.label.hidden = YES;
    
    // set tutor image
    m_nReadTutorFlag = [[NSUserDefaults standardUserDefaults] integerForKey:CONFIG_KEY_READ_CAMERA_TUTOR];
    [self setTutorImage];
    
    // add notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_RESET_CAMERA object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetCamera) name:NOTI_RESET_CAMERA object:nil];
}

- (void) setTutorImage {
    
    if (m_nReadTutorFlag == ReadTuturialFlagTypeNone) return;
    
    self.m_ivTutorial.hidden = YES;
    self.m_ivTutorial.userInteractionEnabled = NO;
    [self.m_ivTutorial removeFromSuperview];
    
    [self initCamera];
}

# pragma mark - Camera Handler

- (void) initCamera {
    
    m_scRecorder = [SCRecorder recorder];
    m_scRecorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    m_scRecorder.maxRecordDuration = CMTimeMake(RECORD_PROGRESS_TOTAL * RECORD_PROGRESS_INTERVAL, 1);
    
    m_scRecorder.delegate = self;
    m_scRecorder.autoSetVideoOrientation = NO;
    
    // rotate preview
//    CGFloat radians = atan2f(self.m_vwPreview.transform.b, self.m_vwPreview.transform.a);
//    CGFloat degrees = radians * (180 / M_PI);
//    CGAffineTransform transform = CGAffineTransformMakeRotation(degrees);
//    self.m_vwPreview.transform = transform;
    
    m_scRecorder.previewView = self.m_vwPreview;
    m_scRecorder.initializeSessionLazily = NO;
    
    // focus view
    self.m_focusView = [[SCRecorderToolsView alloc] initWithFrame:self.m_vwPreview.bounds];
    self.m_focusView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.m_focusView.recorder = m_scRecorder;
    [self.m_vwPreview addSubview:self.m_focusView];
    self.m_focusView.outsideFocusTargetImage = [UIImage imageNamed:@"ic_focus"];
    
    NSError *error;
    
    if (![m_scRecorder prepare:&error]) {
        NSLog(@"Prepare error: %@", error.localizedDescription);
    }
    
    [self resetCamera];
}

- (void) resetCamera {
    
    if (m_scRecorder) {
        
//        if (m_nCameraPosition == CameraPositionFront) {
//            
//            [self onClickCameraPosition:nil];
//        }
        
        if (self.m_btnFlash.selected) {
            
            [self onClickFlash:nil];
        }

        if (m_nCaptureType == CaptureTypeVideo) {
            
            m_nCaptureType = CaptureTypePhoto;
            
            self.m_vwShotProgress.theme.completedColor = [UIColor whiteColor];
            self.m_vwShotProgress.theme.incompletedColor = [UIColor whiteColor];
            self.m_vwShotProgress.progressCounter = 1;
        }
        
        [self prepareSession];
        
//        m_scRecorder.captureSessionPreset = AVCaptureSessionPresetPhoto;
    }
}

- (void)prepareSession {
    
    if (m_scRecorder.session == nil) {
        
        SCRecordSession *session = [SCRecordSession recordSession];
        session.fileType = AVFileTypeQuickTimeMovie;
        
        m_scRecorder.session = session;
    }
    
    [m_scRecorder startRunning];
}

- (void) updateRecordProgress {
    
    // set progress complete color
    self.m_vwShotProgress.theme.completedColor = [UIColor orangeColor];
    
    // set progress
    CMTime currentTime = kCMTimeZero;
    if (m_scRecorder.session != nil) {
        currentTime = m_scRecorder.session.duration;
    }
    
    NSUInteger progress = (NSUInteger)(CMTimeGetSeconds(currentTime) / RECORD_PROGRESS_INTERVAL);
    self.m_vwShotProgress.progressCounter = progress < 2 ? 1 : progress;
}

#pragma mark - SCRecorderDelegate
- (void)recorder:(SCRecorder *)recorder didSkipVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    NSLog(@"Skipped video buffer");
}

- (void)recorder:(SCRecorder *)recorder didReconfigureAudioInput:(NSError *)audioInputError {
    NSLog(@"Reconfigured audio input: %@", audioInputError);
}

- (void)recorder:(SCRecorder *)recorder didReconfigureVideoInput:(NSError *)videoInputError {
    NSLog(@"Reconfigured video input: %@", videoInputError);
}

- (void)recorder:(SCRecorder *)recorder didCompleteSession:(SCRecordSession *)recordSession {
    NSLog(@"didCompleteSession:");
    
    [self saveVideoWithSession:recordSession];
}

- (void)recorder:(SCRecorder *)recorder didInitializeAudioInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    if (error == nil) {
        NSLog(@"Initialized audio in record session");
        
        
    } else {
        NSLog(@"Failed to initialize audio in record session: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didInitializeVideoInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    if (error == nil) {
        NSLog(@"Initialized video in record session");
        
        if (m_bSetFocus) {
            NSLog (@"focus point is %f - %f", m_focusPoint.x, m_focusPoint.y);
            m_bSetFocus = NO;
            [recorder autoFocusAtPoint:m_focusPoint];
        }
    }
    else {
        NSLog(@"Failed to initialize video in record session: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didBeginSegmentInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    NSLog(@"Began record segment: %@", error);
    
    m_scRecorder.frameRate = 24;
}

- (void)recorder:(SCRecorder *)recorder didCompleteSegment:(SCRecordSessionSegment *)segment inSession:(SCRecordSession *)recordSession error:(NSError *)error {
    NSLog(@"Completed record segment at %@: %@ (frameRate: %f)", segment.url, error, segment.frameRate);
}

- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession {
   
    [self updateRecordProgress];
}

- (BOOL)recorderShouldAutomaticallyRefocus:(SCRecorder *)recorder {
    
    return NO;
}

- (void)recorderWillStartFocus:(SCRecorder *__nonnull)recorder {
    
}

@end
