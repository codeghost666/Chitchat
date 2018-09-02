//
//  CCNotificationViewController.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/18/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCNotificationViewController.h"
#import "CCNotificationTableViewCell.h"
#import "CCChatContainerViewController.h"

@interface CCNotificationViewController ()

@end

@implementation CCNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViewController];
    
    [self getNotifications];
}

- (void) viewWillAppear:(BOOL)animated {
    
    // status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
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

# pragma mark - Initialize Handler

- (void) initViewController {
    
    // init variables
    m_aryNotifications = [NSMutableArray new];
    
    // init table view
    self.m_tblNotification.rowHeight = UITableViewAutomaticDimension;
    self.m_tblNotification.estimatedRowHeight = 130.0f;
    
    // add notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_SELECT_NOTIFICATION_USERNAME object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClickUserName:) name:NOTI_SELECT_NOTIFICATION_USERNAME object:nil];
}

# pragma mark - Get Notification Handler

- (void) getNotifications {
    
    SHOW_WAIT_MESSAGE;
    
    [[WebService sharedInstance] getNotificationsWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                                    Success:^(id response) {
                                                        
                                                        // set notifications
                                                        [m_aryNotifications setArray:(NSArray *) response];
                                                        
                                                        // reload data
                                                        [self.m_tblNotification reloadData];
                                                        
                                                        // set read notification
                                                        [self setReadNotification];
                                                        
                                                    } Failure:^(NSString *error) {
                                                       
                                                        SHOW_ERROR_MESSAGE(error);
                                                    }];
}

- (void) setReadNotification {
    
    // get notification ids
    NSString *strNotificationIDs = @"";
    
    for (NotificationObj *notificationObj in m_aryNotifications) {
        
        strNotificationIDs = [strNotificationIDs stringByAppendingString:[NSString stringWithFormat:@",%@", notificationObj.notificaiton_id.stringValue]];
    }
    
    if (strNotificationIDs.length > 0) {
        strNotificationIDs = [strNotificationIDs substringFromIndex:1];
    }

    // set read notifications
    [[WebService sharedInstance] readNotificationWithNotificationIds:strNotificationIDs
                                                             Success:^(id response) {
                                                                 
                                                                 DISMISS_MESSAGE;
                                                                 
                                                             } Failure:^(NSString *error) {
                                                                
                                                                 SHOW_ERROR_MESSAGE(error);
                                                             }];
}

# pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return m_aryNotifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCNotificationTableViewCell* cell = [[NSBundle mainBundle] loadNibNamed:@"CCNotificationTableViewCell"
                                                                      owner:nil
                                                                    options:nil][0];
    cell.notificationObj = m_aryNotifications[indexPath.row];
    
    return cell;
}

# pragma mark - Notification Handler
- (void) onClickUserName:(NSNotification *) notification {
    
    NSNumber *user_qb_userid = notification.userInfo[@"user_qb_userid"];
    NSString *user_name = notification.userInfo[@"user_name"];
    
    // check user gender
    if ([GlobalData sharedInstance].g_selfUser.user_gender.integerValue == UserGenderMale) {
        
        if ([GlobalData sharedInstance].g_bVIPUser) {
            
            if (user_qb_userid.integerValue > 0) {
                
                [self getDialogWithUserName:user_name QBUserId:user_qb_userid];
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
        
        if (user_qb_userid.integerValue > 0) {
            
            [self getDialogWithUserName:user_name QBUserId:user_qb_userid];
        }
        else {
            
            SHOW_ERROR_MESSAGE(@"Sorry, user didn't connect to chat yet.");
        }
    }
}

# pragma mark - QuickBlox Handler

- (void) getDialogWithUserName:(NSString *) user_name QBUserId:(NSNumber *) user_qb_userid {
    
    // get all dialog
    SHOW_STATU_MESSAGE(@"Connecting to chat...");
    [[WebService sharedInstance] getQBChatDialogWithUserObj:[GlobalData sharedInstance].g_selfUser
                                                 QBUserName:user_name
                                                    Success:^(id response) {
                                                        
                                                        NSArray *aryDialogs = (NSArray *) response;
                                                        
                                                        if (aryDialogs.count > 0) {
                                                            
                                                            [self gotoChatViewControllerWithDialog:aryDialogs[0]];
                                                        }
                                                        else {
                                                            
                                                            [self createDialogWithQBUserId:user_qb_userid];
                                                        }
                                                    } Failure:^(NSString *error) {
                                                        
                                                        SHOW_ERROR_MESSAGE(error);
                                                    }];
}

- (void) createDialogWithQBUserId:(NSNumber *) user_qb_userid {
    
    [[QMServicesManager instance].chatService
     createPrivateChatDialogWithOpponentID:user_qb_userid.integerValue
     completion:^(QBResponse * _Nonnull response, QBChatDialog * _Nullable createdDialog) {
         
         if (!response) {
             
             QBChatDialog *dialog = [[QMServicesManager instance].chatService.dialogsMemoryStorage privateChatDialogWithOpponentID:user_qb_userid.integerValue];
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


@end
