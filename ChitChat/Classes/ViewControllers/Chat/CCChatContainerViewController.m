//
//  CCChatContainerViewController.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/28/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCChatContainerViewController.h"
#import "CCChatViewController.h"

@interface CCChatContainerViewController ()

@end

@implementation CCChatContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViewController];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
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

# pragma mark - Event Handler

- (IBAction)onClickBlockUser:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                   message:@"Are you sure to block this user?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                     }];

    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                          [self deleteDialog];
                                                      }];
    
    [alert addAction:noAction];
    [alert addAction:yesAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) deleteDialog {
    
    SHOW_WAIT_MESSAGE;
    
    [[QMServicesManager instance].chatService deleteDialogWithID:self.m_chatDialog.ID
                                                      completion:^(QBResponse * _Nonnull response) {
                                                          
                                                          if (response.success) {
                                                              
                                                              DISMISS_MESSAGE;
                                                              [self onClickBack:nil];
                                                          }
                                                          else {
                                                              
                                                              SHOW_ERROR_MESSAGE(response.error.description);
                                                          }
                                                      }];
}

# pragma mark - Initialize Handler

- (void) initViewController {
    
    // set title
    self.m_lblTitle.text = self.m_chatDialog.name;
    
    // add chat view controller
    CCChatViewController *chatVC = [[CCChatViewController alloc] init];
    chatVC.dialog = self.m_chatDialog;
    [self addChildViewController:chatVC];
    [self.m_vwMain addSubview:chatVC.view];
    
    [self addConstraintToView:chatVC.view];
    
    [self addNotifications];
}

- (void)addConstraintToView:(UIView *)view {
    //add constraint
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //center x
    [self.m_vwMain addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.m_vwMain
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.f
                                                                 constant:0.f]];
    
    //center y
    [self.m_vwMain addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.m_vwMain
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.f
                                                                 constant:0.f]];
    
    //equal width
    [self.m_vwMain addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.m_vwMain
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1.f
                                                                 constant:0.f]];
    
    //equal height
    [self.m_vwMain addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.m_vwMain
                                                                attribute:NSLayoutAttributeHeight
                                                               multiplier:1.f
                                                                 constant:0.f]];
}

# pragma mark - Notification Handler

- (void) addNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_CHANGE_TITLE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTitle:) name:NOTI_CHANGE_TITLE object:nil];
}

- (void) changeTitle:(NSNotification *) notification {
    
    self.m_lblTitle.text = notification.userInfo[@"title"];
}

@end
