//
//  CCWatchViewController.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/19/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCWatchViewController.h"
#import "CCChatContainerViewController.h"


#define WATCH_PROGRESS_UPDATE_TIME      0.05f
#define WATCH_PROGRESS_UPDATE_COUNT     200

@interface CCWatchViewController ()

@end

@implementation CCWatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViewController];
}

- (void) viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];
    
    if (self.m_vwTimer.tag == 0) {
        
        [self.view layoutIfNeeded];
        
        self.m_vwTimer.label.frame = self.m_vwTimer.bounds;
        self.m_vwTimer.tag = 1;
    }
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

- (IBAction)onClickFlag:(id)sender {
    
    [self showNextStory];
}

- (IBAction)onClickChat:(id)sender {
    
    // reset timer
    [self stopWatchTimer];
    
    // stop video play
    if (self.m_vwVideo.isPlaying) [self.m_vwVideo stopWithReleaseVideo:YES];
    
    // check user gender
    if ([GlobalData sharedInstance].g_selfUser.user_gender.integerValue == UserGenderMale) {
        
        if ([GlobalData sharedInstance].g_bVIPUser) {

            StoryObj *storyObj = m_aryStories[m_nWatchedStoryCount];
            if (storyObj.story_qb_userid.integerValue > 0) {
                
                [self getDialog];
            }
            else {
                
                SHOW_ERROR_MESSAGE(@"Sorry, user didn't connect to chat yet.");
            }
        }
        else {
            
            // show vip view controller
            UIViewController *vipVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCVIPViewController"];
            [self.navigationController pushViewController:vipVC animated:YES];
        }
    }
    else {
        
        StoryObj *storyObj = m_aryStories[m_nWatchedStoryCount];
        if (storyObj.story_qb_userid.integerValue > 0) {
            
            [self getDialog];
        }
        else {
            
            SHOW_ERROR_MESSAGE(@"Sorry, user didn't connect to chat yet.");
        }
    }
}

- (IBAction)onClickLike:(id)sender {
    
    if (self.m_btnLike.selected) return;
    
    StoryObj *storyObj = m_aryStories[m_nWatchedStoryCount];
    
    [[WebService sharedInstance] setLikeStoryWithStoryId:storyObj.story_id
                                                  UserId:[GlobalData sharedInstance].g_selfUser.user_id
                                                UserName:[GlobalData sharedInstance].g_selfUser.user_name
                                                 Success:^(id response) {
                                                     
                                                     self.m_btnLike.selected = YES;
                                                     
                                                     storyObj.story_like_count = @(storyObj.story_like_count.intValue + 1);
                                                     storyObj.story_is_liked = @(YES);
                                                     
                                                     NSString *strLikeCount = [[GlobalData sharedInstance] formattedStringWithCount:storyObj.story_like_count.intValue];
                                                     [self.m_btnLike setTitle:strLikeCount forState:UIControlStateNormal];
                                                     [self.m_btnLike setTitle:strLikeCount forState:UIControlStateSelected];
                                                     
                                                     // send notification
//                                                     NSDictionary *dictResult = (NSDictionary *) response;
//                                                     if ([NSObject isValid:dictResult[@"noti_count"]]) {
//                                                         
//                                                         [self postNotificationWithOSUserId:storyObj.story_os_userid
//                                                                                  NotiCount:dictResult[@"noti_count"]
//                                                                                    Message:dictResult[@"message"]];
//                                                     }
                                                     
                                                 } Failure:^(NSString *error) {
                                                    
                                                     SHOW_ERROR_MESSAGE(error);
                                                 }];
}

- (IBAction)onClickReplay:(id)sender {
    
    m_nWatchedStoryCount = -1;
    self.m_vwEnd.hidden = YES;
    
    [self showNextStory];
}

- (IBAction)onClickAddStory:(id)sender {
    
    [self onClickCamera:nil];
}

- (IBAction)onClickBack:(id)sender {
    
    [self.m_vwVideo stopWithReleaseVideo:YES];
    
    // set read story
    if (m_aryStories.count == 0) {
        
        // go to home view controller
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        
        __weak typeof (self) weak_self = self;
        [self setReadStoryWithSuccess:^{
            
            // go to home view controller
            [weak_self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
}

- (IBAction)onClickCamera:(id)sender {
    
    // set read story
    if (m_aryStories.count == 0) {
        
        // go to camera view
        UIViewController *cameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCCameraViewController"];
        [self.navigationController pushViewController:cameraVC animated:YES];
    }
    else {
        
        __weak typeof (self) weak_self = self;
        [self setReadStoryWithSuccess:^{
            
            // go to camera view
            UIViewController *cameraVC = [weak_self.storyboard instantiateViewControllerWithIdentifier:@"CCCameraViewController"];
            [weak_self.navigationController pushViewController:cameraVC animated:YES];
        }];
    }
}

- (IBAction)onTapTutorial:(id)sender {
    
    switch (m_nReadTutorFlag) {
            
        case ReadTuturialFlagTypeNone:
            m_nReadTutorFlag = ReadTuturialFlagTypeWatch1st;
            break;
            
        case ReadTuturialFlagTypeWatch1st:
            m_nReadTutorFlag = ReadTuturialFlagTypeWatch2nd;
            
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:m_nReadTutorFlag forKey:CONFIG_KEY_READ_WATCH_TUTOR];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self setTutorImage];
}

- (IBAction)onTapOperation:(id)sender {
    
    [self showNextStory];
}

- (IBAction)onSwipeRight:(id)sender {
    
    [self onClickBack:nil];
}

- (IBAction)onSwipeLeft:(id)sender {
    
    [self onClickCamera:nil];
}


# pragma mark - Initialize Handler

- (void) initViewController {

    // init data variables
    m_aryStories    = [NSMutableArray new];
    
    m_nWatchedStoryCount = -1;
    
    m_nReadTutorFlag = [[NSUserDefaults standardUserDefaults] integerForKey:CONFIG_KEY_READ_WATCH_TUTOR];
    
    // init timer view
    MDRadialProgressTheme *newTheme = [[MDRadialProgressTheme alloc] init];
    newTheme.thickness = 8.0f;
    newTheme.completedColor = [UIColor whiteColor];
    newTheme.incompletedColor = [@"#9B9B9B" representedColor];
    newTheme.centerColor = [UIColor clearColor];
    newTheme.sliceDividerHidden = YES;
    newTheme.labelColor = [UIColor whiteColor];
    newTheme.labelShadowColor = [UIColor clearColor];
    newTheme.font = [UIFont fontWithName:@"AvenirLT-Medium" size:14.f];
    
    self.m_vwTimer.theme = newTheme;
    self.m_vwTimer.progressTotal = WATCH_PROGRESS_UPDATE_COUNT;
    self.m_vwTimer.progressCounter = 0;
    
    self.m_vwTimer.labelTextBlock = ^NSString * (MDRadialProgressView *progressView) {
        
        return [NSString stringWithFormat:@"%d", (int)(m_aryStories.count - m_nWatchedStoryCount - 1)];
    };
    
    // set video view
    self.m_vwVideo = [[CTVideoView alloc] init];
    [self.view addSubview:self.m_vwVideo];
    [self.view sendSubviewToBack:self.m_vwVideo];
    [self.m_vwVideo fill];

    // init views
    self.m_vwVideo.hidden = YES;
    self.m_ivPhoto.hidden = NO;
    self.m_ivEdit.hidden = YES;
    self.m_vwOperation.hidden = YES;
    self.m_vwEnd.hidden = YES;
    self.m_btnCamera.hidden = YES;
    self.m_ivTutorial.hidden = NO;
    
    // init tutor image
    [self setTutorImage];
    
    // add notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_SHOW_NEXT_STORY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNextStory) name:NOTI_SHOW_NEXT_STORY object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_CONNECT_CHAT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClickChat:) name:NOTI_CONNECT_CHAT object:nil];
}

- (void) setTutorImage {
    
    switch (m_nReadTutorFlag) {
            
        case ReadTuturialFlagTypeNone:
            self.m_ivTutorial.image = [UIImage imageNamed:@"img_watch_tutor1"];
            break;
            
        case ReadTuturialFlagTypeWatch1st:
            self.m_ivTutorial.image = [UIImage imageNamed:@"img_watch_tutor2"];
            break;
            
        default: {

            // remove tutorial image
            self.m_ivTutorial.hidden = YES;
            self.m_ivTutorial.userInteractionEnabled = NO;
            [self.m_ivTutorial removeFromSuperview];
            
            // get story list
            [self getStories];
        }
            break;
    }
}

# pragma mark - Get Stories Handler

- (void) getVIPStories {
    
    SHOW_WAIT_MESSAGE;
    [[WebService sharedInstance] getVIPStoriesWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                                 Success:^(id response) {
 
                                                     DISMISS_MESSAGE;
                                                     
                                                     [self setStories:(NSArray *) response];
                                                     
                                                 } Failure:^(NSString *error) {
                                                    
                                                     SHOW_ERROR_MESSAGE(error);
                                                 }];
}

- (void) getStories {
    
    SHOW_WAIT_MESSAGE;
    [[WebService sharedInstance] getStoriesWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                           LocationId:self.m_locationObj.location_id
                                              Success:^(id response) {
                                                  
                                                  DISMISS_MESSAGE;
                                                  
                                                  [self setStories:(NSArray *) response];
                                                  
                                              } Failure:^(NSString *error) {
                                                 
                                                  SHOW_ERROR_MESSAGE(error);
                                              }];
}

- (void) setStories:(NSArray *) aryStories {
    
    // set story list
    [m_aryStories removeAllObjects];
    [m_aryStories setArray:aryStories];
    
    // show story view
    if (m_aryStories.count > 0) {
        
        // init views
        self.m_vwOperation.hidden = NO;
        self.m_btnCamera.hidden = NO;
        
        // show stories
        [self showNextStory];
    }
    else {
        
        [self showEndView];
    }
}


# pragma mark - Show Story Handler

- (void) showNextStory {
    
    if (m_nWatchedStoryCount < (NSInteger)(m_aryStories.count - 1)) {
        
        m_nWatchedStoryCount ++;
    }
    else {
        
        [self showEndView];
        return;
    }
    
    // ---------- reset previous operation
    // reset timer
    [self stopWatchTimer];
    
    // stop video play
    if (self.m_vwVideo.isPlaying) [self.m_vwVideo stopWithReleaseVideo:YES];
    
    // show photo image
    self.m_ivPhoto.hidden = NO;
    
    
    // ----------- show new story
    // set data and controls
    StoryObj *storyObj = m_aryStories[m_nWatchedStoryCount];
    
    // set user name
    self.m_lblUserName.text = storyObj.story_user_name;
    
    // set story time
    self.m_lblTimeAgo.text = [storyObj.story_created timeAgoSinceNow];
    
    // set like button
    self.m_btnLike.selected = storyObj.story_is_liked.boolValue;
    self.m_btnLike.userInteractionEnabled = !self.m_btnLike.selected;
    
    NSString *strLikeCount = [[GlobalData sharedInstance] formattedStringWithCount:storyObj.story_like_count.intValue];
    [self.m_btnLike setTitle:strLikeCount forState:UIControlStateNormal];
    [self.m_btnLike setTitle:strLikeCount forState:UIControlStateSelected];
    
    // show story
    [SVProgressHUD showWithStatus:@""];
    if (storyObj.story_type.integerValue == StoryTypePhoto) { // Photo
        
        self.m_ivEdit.hidden = YES;
        self.m_vwVideo.hidden = YES;
        
        // download image from server
        [self.m_ivPhoto setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:storyObj.story_main_url]]
                              placeholderImage:nil
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                           
                                           DISMISS_MESSAGE;
                                           self.m_ivPhoto.image = image;
                                           [self startWatchTimer];
                                           
                                       } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                           
                                           self.m_ivPhoto.image = [UIImage imageNamed:@"bg_main"];
                                           [self startWatchTimer];
                                       }];
    }
    else {  // Video
        
        // set thumbnail image
        [self.m_ivPhoto setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:storyObj.story_tumb_url]]
                              placeholderImage:nil
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                           
                                           DISMISS_MESSAGE;
                                           self.m_ivPhoto.image = image;
                                           
                                           
                                       } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                           
                                           self.m_ivPhoto.image = [UIImage imageNamed:@"bg_main"];
                                       }];
        
        // set video
        self.m_vwVideo.operationDelegate = self;
        self.m_vwVideo.videoUrl = [NSURL URLWithString:storyObj.story_main_url];
        [self.m_vwVideo prepare];
    }
}

- (void) updateWatchTimerProgress:(NSTimer *) timer {
    
    // check show next or not
    if (self.m_vwTimer.progressCounter >= self.m_vwTimer.progressTotal) {
        
        m_nWatchedStoryCount < m_aryStories.count - 1 ? [self showNextStory] : [self showEndView];
        
        return;
    }
    
    StoryObj *storyObj = m_aryStories[m_nWatchedStoryCount];
    self.m_vwTimer.progressCounter += storyObj.story_type.integerValue == StoryTypePhoto ? 2 : 1;
}

- (void) showEndView {

    // reset timer
    [self stopWatchTimer];
    
    // stop video
    if (self.m_vwVideo.isPlaying)
        [self.m_vwVideo stopWithReleaseVideo:YES];
    
    
    // dismiss progress
    DISMISS_MESSAGE;
    
    // set end view
    self.m_vwEnd.hidden = NO;
    self.m_btnReplayStories.hidden = m_aryStories.count == 0;
    self.m_lblEnd.text = [NSString stringWithFormat:@"No new stories from \n %@", self.m_locationObj.location_name.uppercaseString];
}

# pragma mark - Timer Handler

- (void) startWatchTimer {
    
    if (m_timerWatch) [m_timerWatch invalidate];
    m_timerWatch = [NSTimer scheduledTimerWithTimeInterval:WATCH_PROGRESS_UPDATE_TIME
                                                    target:self
                                                  selector:@selector(updateWatchTimerProgress:)
                                                  userInfo:nil
                                                   repeats:YES];
    
    self.m_vwTimer.theme.completedColor = [UIColor whiteColor];
}

- (void) stopWatchTimer {
    
    if (m_timerWatch) {
        
        [m_timerWatch invalidate];
        m_timerWatch = nil;
    }
    
    self.m_vwTimer.progressCounter = 1;
    self.m_vwTimer.theme.completedColor = [@"#9B9B9B" representedColor];
}


# pragma mark - CTVideoView Operation Delegate
- (void) videoViewDidFinishPrepare:(CTVideoView *)videoView {
    
    DISMISS_MESSAGE;
    
    StoryObj *storyObj = m_aryStories[m_nWatchedStoryCount];
    
    // set edit image
    self.m_ivEdit.hidden = NO;
    [self.m_ivEdit setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:storyObj.story_edit_url]]
                         placeholderImage:nil
                                  success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                      
                                      [self.m_vwVideo play];
                                      self.m_ivEdit.image = image;
                                      
                                  } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                      
                                      [self.m_vwVideo play];
                                      self.m_ivEdit.hidden = YES;
                                  }];
}

- (void) videoViewDidStartPlaying:(CTVideoView *)videoView {
    
    self.m_vwVideo.hidden = NO;
    self.m_ivPhoto.hidden = YES;
    
    [self startWatchTimer];
}

# pragma mark - Set Read Story Handler
- (void) setReadStoryWithSuccess:(void (^)(void)) read_success {
    
    // reset timer
    [self stopWatchTimer];
    
    // set read story to server
    StoryObj *storyObj = m_aryStories[m_nWatchedStoryCount];
    NSNumber *location_id = storyObj.story_location_id;
    
    [[WebService sharedInstance] setReadStoryWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                             LocationId:location_id
                                            LastStoryId:storyObj.story_id
                                                Success:^(id response) {
                                                    
                                                    return read_success ();
                                                    
                                                } Failure:^(NSString *error) {
                                                   
                                                    SHOW_ERROR_MESSAGE(error);
                                                }];
}

# pragma mark - QuickBlox Handler
- (void) getDialog {

    // get all dialog
    StoryObj *storyObj = m_aryStories[m_nWatchedStoryCount];
    SHOW_STATU_MESSAGE(@"Connecting to chat...");
    [[WebService sharedInstance] getQBChatDialogWithUserObj:[GlobalData sharedInstance].g_selfUser
                                                 QBUserName:storyObj.story_user_name
                                                    Success:^(id response) {
                                                        
                                                        NSArray *aryDialogs = (NSArray *) response;
                                                        
                                                        if (aryDialogs.count > 0) {
                                                            
                                                            [self gotoChatViewControllerWithDialog:aryDialogs[0]];
                                                        }
                                                        else {
                                                            
                                                            [self createDialog];
                                                        }
                                                    } Failure:^(NSString *error) {
    
                                                        SHOW_ERROR_MESSAGE(error);
                                                    }];
}

- (void) createDialog {
    
    StoryObj *storyObj = m_aryStories[m_nWatchedStoryCount];
    
    [[QMServicesManager instance].chatService createPrivateChatDialogWithOpponentID:storyObj.story_qb_userid.integerValue
                                                                         completion:^(QBResponse * _Nonnull response, QBChatDialog * _Nullable createdDialog) {
                                                                            
                                                                             if (!response) {
                                                                                 
                                                                                 QBChatDialog *dialog = [[QMServicesManager instance].chatService.dialogsMemoryStorage privateChatDialogWithOpponentID:storyObj.story_qb_userid.integerValue];
                                                                                 [self gotoChatViewControllerWithDialog:dialog];
                                                                             }
                                                                             else if (response.success) {
                                                                                 
                                                                                 [self gotoChatViewControllerWithDialog:createdDialog];
                                                                             }
                                                                             else {
                                                                                 
                                                                                 SHOW_ERROR_MESSAGE(response.error.description);
                                                                             }
                                                                         }];    
}

- (void) gotoChatViewControllerWithDialog:(QBChatDialog *) dialog {

    CCChatContainerViewController *chatContainerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCChatContainerViewController"];
    chatContainerVC.m_chatDialog = dialog;
    
    [self.navigationController pushViewController:chatContainerVC animated:YES];
}

# pragma mark - Post One Signal Notification

- (void) postNotificationWithOSUserId:(NSString *) user_os_id
                            NotiCount:(NSString *) noti_count
                              Message:(NSString *) message {
    
    [OneSignal postNotification:@{
                                  @"contents"           : @{@"en" : message},
                                  @"ios_badgeType"      : @"Increase",
                                  @"ios_badgeCount"     : noti_count,
                                  @"include_player_ids" : @[user_os_id]
                                  }
                      onSuccess:^(NSDictionary *result) {
                          
                      } onFailure:^(NSError *error) {
                          
                          SHOW_ERROR_MESSAGE(error.localizedDescription);
                      }];
}

@end
