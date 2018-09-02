//
//  CCHomeViewController.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/17/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCHomeViewController.h"
#import "CCHomeTableViewCell.h"
#import "CCWatchViewController.h"
#import "CCCameraViewController.h"

@interface CCHomeViewController ()<QMChatServiceDelegate, QMChatConnectionDelegate>

@end

@implementation CCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViewController];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // set tutorial image view
    [self setTutorialImage];
    
    // save user location
    [self saveLocation];
    
    self.m_btnChat.selected = NO;
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

- (IBAction)onClickNotification:(id)sender {
    
    UIViewController *notificationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCNotificationViewController"];
    [self.navigationController pushViewController:notificationVC animated:YES];
}

- (IBAction)onClickChat:(id)sender {
    
    self.m_btnChat.selected = NO;
    
    UIViewController *chatListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCChatListViewController"];
    [self.navigationController pushViewController:chatListVC animated:YES];
}

- (IBAction)onClickCamera:(id)sender {
    
    UIViewController *cameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCCameraViewController"];
    [self.navigationController pushViewController:cameraVC animated:YES];
}

- (IBAction)onClickExplore:(id)sender {
    
    UIViewController *exploreVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCExploreViewController"];
    [self.navigationController pushViewController:exploreVC animated:YES];
}

- (IBAction)onClickSettings:(id)sender {
    
    UIViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCSettingsViewController"];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

- (IBAction)onTapGesture:(id)sender {
    
    switch (m_nReadFlag) {
        
        case ReadTuturialFlagTypeNone:
            m_nReadFlag = ReadTuturialFlagTypeHome1st;
            break;
            
        case ReadTuturialFlagTypeHome1st:
            m_nReadFlag = ReadTuturialFlagTypeHome2nd;
            break;
            
        case ReadTuturialFlagTypeHome2nd:
            m_nReadFlag = ReadTuturialFlagTypeHome3rd;
        default:
            break;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:m_nReadFlag forKey:CONFIG_KEY_READ_HOME_TUTOR];
    [userDefaults synchronize];
    
    [self setTutorialImage];
}

- (IBAction)onSwipeRightGesture:(id)sender {
    
    [self onTapGesture:nil];
}

- (IBAction)onSwipeLeftGesture:(id)sender {
    
    if (m_nReadFlag == ReadTuturialFlagTypeNone) return;
    
    [self onTapGesture:nil];
    
    // goto camera view controlller
    [self onClickCamera:nil];
}

# pragma mark - Initialize Handler

- (void) initViewController {

    // init variables
    m_aryData = [NSMutableArray new];
    m_nReadFlag = [[NSUserDefaults standardUserDefaults] integerForKey:CONFIG_KEY_READ_HOME_TUTOR];

    
    // add notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_GET_UNREAD_NOTIFICATIONS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNotification) name:NOTI_GET_UNREAD_NOTIFICATIONS object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_DID_RECEIVE_NEW_CHAT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceivedNewChat) name:NOTI_DID_RECEIVE_NEW_CHAT object:nil];
    
    // addd chat delegate
    [[QMServicesManager instance].chatService addDelegate:self];
}

- (void) setTutorialImage {
    
    switch (m_nReadFlag) {
            
        case ReadTuturialFlagTypeNone:
            self.m_ivTutorial.image = [UIImage imageNamed:@"img_home_tutor1"];
            break;
            
        case ReadTuturialFlagTypeHome1st:
            self.m_ivTutorial.image = [UIImage imageNamed:@"img_home_tutor2"];
            break;
            
        case ReadTuturialFlagTypeHome2nd:
            self.m_ivTutorial.image = [UIImage imageNamed:@"img_home_tutor3"];
            break;
            
        default:
            self.m_ivTutorial.hidden = YES;
            self.m_ivTutorial.userInteractionEnabled = NO;
            [self.m_ivTutorial removeFromSuperview];
            break;
    }
}

# pragma mark - Notification Handler

- (void) setNotification {
    
    self.m_btnNotification.selected = YES;
}

- (void) onReceivedNewChat {
    
    self.m_btnChat.selected = YES;
}


# pragma mark - Save User Location Handler

- (void) saveLocation {

    // check valid user location
    if (![NSObject isValid:[GlobalData sharedInstance].g_selectedLocation]
        || [[GlobalData sharedInstance].g_selectedLocation.location_name isEqualToString:@""]
        || [GlobalData sharedInstance].g_selectedLocation.location_type.intValue == LocationTypeNone) {
        
        SHOW_ERROR_MESSAGE(@"Your location was not set yet.");
        
        [GlobalData sharedInstance].g_selectedLocation = [[LocationObj alloc] init];
        [[GlobalData sharedInstance] saveConfigData];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
//    if (m_nReadFlag == ReadTuturialFlagTypeHome3rd) SHOW_WAIT_MESSAGE;
    
    [[WebService sharedInstance] saveLocationWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                        LocationObject:[GlobalData sharedInstance].g_selectedLocation
                                                Success:^(id response) {
                                                    
                                                    NSDictionary *dictResult = (NSDictionary *) response;
                                                    
                                                    // check valid user
                                                    if (![NSObject isValid:dictResult[@"user"]]) {
                                                        
                                                        NSString *message = @"Your account is not actived.\nPlease contact administrator.";
                                                        
                                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                                                                       message:message
                                                                                                                preferredStyle:UIAlertControllerStyleAlert];
                                                        
                                                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay"
                                                                                                           style:UIAlertActionStyleCancel
                                                                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                                                             
                                                                                                             [GlobalData sharedInstance].g_selfUser = [[UserObj alloc] init];
                                                                                                             [GlobalData sharedInstance].g_selectedLocation = [[LocationObj alloc] init];
                                                                                                             [[GlobalData sharedInstance] saveConfigData];
                                                                                                             
                                                                                                             [self.navigationController popToRootViewControllerAnimated:NO];
                                                                                                         }];
                                                        
                                                        [alert addAction:okAction];
                                                        [self presentViewController:alert animated:YES completion:nil];
                                                    }
                                                    else {  // valid user
                                                        
                                                        // save user profile
                                                        [GlobalData sharedInstance].g_selfUser = [UserObj instanceWithDict:dictResult[@"user"]];
                                                        
                                                        // save my location
                                                        [GlobalData sharedInstance].g_selectedLocation = [LocationObj instanceWithDict:dictResult[@"user_location"]];
                                                        
                                                        [[GlobalData sharedInstance] saveConfigData];
                                                        
                                                        // get location lists
                                                        [m_aryData removeAllObjects];
                                                        
                                                        [m_aryData addObject:[LocationObj instanceWithDict:dictResult[@"location"]]]; // add other gender by same location
                                                        
                                                        NSArray *aryFeatured = [NSArray arrayWithArray:dictResult[@"featured_locations"]];
                                                        for (NSDictionary *dict in aryFeatured) {
                                                            
                                                            LocationObj *locationObj = [LocationObj instanceWithDict:dict];
                                                            [m_aryData addObject:locationObj];
                                                        }
                                                        
                                                        // reload data
                                                        [self.m_tblStory reloadData];
                                                        
                                                        // check notification
                                                        [self checkNotification];
                                                        
                                                        // get weather
//                                                        [self getTemperature];
                                                        
                                                        // set like count
                                                        NSString *strLikes = [[GlobalData sharedInstance] formattedStringWithCount:[GlobalData sharedInstance].g_selfUser.user_star_count.intValue];
                                                        
                                                        [self.m_btnNotification setTitle:strLikes forState:UIControlStateNormal];
                                                        [self.m_btnNotification setTitle:strLikes forState:UIControlStateSelected];
                                                    }
                                                    
                                                } Failure:^(NSString *error) {
                                                   
                                                    SHOW_ERROR_MESSAGE(error);
                                                }];
}

# pragma mark - Get Notification Handler

- (void) checkNotification {
    
    [[WebService sharedInstance] checkNotificationWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                                     Success:^(id response) {
                                                         
//                                                         DISMISS_MESSAGE;
                                                         
                                                         NSNumber *notiCount = (NSNumber *) response;
                                                         self.m_btnNotification.selected = notiCount.integerValue > 0;
                                                         
                                                     } Failure:^(NSString *error) {
                                                        
                                                         SHOW_ERROR_MESSAGE(error);
                                                     }];
}

# pragma mark - Get Temperature Handler

- (void) getTemperature {
    
    [[WebService sharedInstance] getWeatherDataWithUserLatitude:[GlobalData sharedInstance].g_selfUser.user_lat
                                                      Longitude:[GlobalData sharedInstance].g_selfUser.user_long
                                                        Success:^(id response) {
                                                            
                                                            [GlobalData sharedInstance].g_curTemperature = (NSNumber *) response;
                                                            
                                                        } Failure:^(NSString *error) {
                                                           
                                                            SHOW_ERROR_MESSAGE(error);
                                                        }];
}

# pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return m_aryData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCHomeTableViewCell* cell = [[NSBundle mainBundle] loadNibNamed:@"CCHomeTableViewCell" owner:nil options:nil][0];
    LocationObj *locationObj = m_aryData[indexPath.row];
    cell.locationObj = locationObj;
    
    return cell;
}

# pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LocationObj *selectedLocation = m_aryData[indexPath.row];
    [self watchStoryWithLocation:selectedLocation];
}

# pragma mark - Watch Story Handler

- (void) watchStoryWithLocation:(LocationObj *) locationObj {
    
    if (![locationObj.location_name isEqualToString:@"#Sexy"]) {
        
        CCWatchViewController *watchViewController = (CCWatchViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CCWatchViewController"];
        watchViewController.m_locationObj = locationObj;
        [self.navigationController pushViewController:watchViewController animated:YES];
    }
    else {

        if (![[NSUserDefaults standardUserDefaults] boolForKey:CONFIG_KEY_CHECK_18_OLDS]) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                           message:@"You must be 18+ to view the following #Tag"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:nil];
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"I'm 18"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                 
                                                                  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CONFIG_KEY_CHECK_18_OLDS];
                                                                  [[NSUserDefaults standardUserDefaults] synchronize];
                                                                  
                                                                  CCWatchViewController *watchViewController = (CCWatchViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CCWatchViewController"];
                                                                  watchViewController.m_locationObj = locationObj;
                                                                  [self.navigationController pushViewController:watchViewController animated:YES];
                                                              }];
            
            [alert addAction:cancelAction];
            [alert addAction:yesAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            
            CCWatchViewController *watchViewController = (CCWatchViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CCWatchViewController"];
            watchViewController.m_locationObj = locationObj;
            [self.navigationController pushViewController:watchViewController animated:YES];
        }
    }
}

#pragma mark -
#pragma mark Chat Service Delegate

- (void)chatService:(QMChatService *)chatService didAddChatDialogsToMemoryStorage:(NSArray *)chatDialogs {
    
}

- (void)chatService:(QMChatService *)chatService didAddChatDialogToMemoryStorage:(QBChatDialog *)chatDialog {
    
}

- (void)chatService:(QMChatService *)chatService didUpdateChatDialogInMemoryStorage:(QBChatDialog *)chatDialog {
    
}

- (void)chatService:(QMChatService *)chatService didUpdateChatDialogsInMemoryStorage:(NSArray *)dialogs {
    
}

- (void)chatService:(QMChatService *)chatService didReceiveNotificationMessage:(QBChatMessage *)message createDialog:(QBChatDialog *)dialog {
    
}

- (void)chatService:(QMChatService *)chatService didAddMessageToMemoryStorage:(QBChatMessage *)message forDialogID:(NSString *)dialogID {
    
    [self onReceivedNewChat];
}

- (void)chatService:(QMChatService *)chatService didAddMessagesToMemoryStorage:(NSArray *)messages forDialogID:(NSString *)dialogID {
    
}

- (void)chatService:(QMChatService *)chatService didDeleteChatDialogWithIDFromMemoryStorage:(NSString *)chatDialogID {
    
}




@end
