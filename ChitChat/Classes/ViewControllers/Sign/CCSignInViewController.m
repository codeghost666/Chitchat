//
//  CCSignInViewController.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/13/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCSignInViewController.h"

@interface CCSignInViewController ()

@end

@implementation CCSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViewController];
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

- (IBAction)onClickNext:(id)sender {
    
    [self.m_txtUserName resignFirstResponder];
    [self.m_txtPassword resignFirstResponder];
    
    self.m_txtUserName.text = [self.m_txtUserName.text trim];
    
    if (![self.m_txtUserName isValidText]) {
        
        SHOW_ERROR_MESSAGE(@"Invalid user name!");
    }
    else if (![self.m_txtPassword isValidText]) {
        
        SHOW_ERROR_MESSAGE(@"Invalid password");
    }
    else {
        
        SHOW_WAIT_MESSAGE;
        
        [[WebService sharedInstance] signinWithUserName:self.m_txtUserName.text
                                               Password:self.m_txtPassword.text
                                               DeviceID:[GlobalData sharedInstance].g_strDeviceID
                                            DeviceToken:[GlobalData sharedInstance].g_strDeviceToken
                                               Latitude:@(self.m_myLocation.coordinate.latitude)
                                              Longitude:@(self.m_myLocation.coordinate.longitude)
                                                Success:^(id response) {
                                                    
                                                    [GlobalData sharedInstance].g_selfUser = (UserObj *) response;
                                                    
                                                    SHOW_STATU_MESSAGE(@"Processing signin...");
                                                    
                                                    if ([GlobalData sharedInstance].g_selfUser.user_qb_userid.integerValue > 0) {
                                                        
                                                        [[GlobalData sharedInstance] saveConfigData];
                                                        [self signinQBUser];
                                                    }
                                                    else {
                                                    
                                                        [self registerQBUser];
                                                    }
                                                    
                                                    // register one signal user id
                                                    [self registerOSUser];
                                                    
                                                } Failure:^(NSString *error) {
                                                    
                                                    SHOW_ERROR_MESSAGE(error);
                                                }];
    }
}

- (IBAction)onClickSignUp:(id)sender {
    
    [self onClickBack:nil];
}

# pragma mark - Initialize Handler

- (void) initViewController {
    
    // init text fields
    self.m_txtUserName.textFieldStyle = CustomTextFieldStyleDefault;
    self.m_txtPassword.textFieldStyle = CustomTextFieldStyleSecure;
    
    self.m_txtUserName.tintColor = [UIColor whiteColor];
    self.m_txtPassword.tintColor = [UIColor whiteColor];
    
    // init label
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self.m_lblSignUp.text];
    NSRange range = [self.m_lblSignUp.text rangeOfString:@"Sign Up"];
    
    UIFont *font = [UIFont fontWithName:@"AvenirNextLTPro-Bold" size:self.m_lblSignUp.font.pointSize];
    if (![NSObject isValid:font]) {
        
        font = self.m_lblSignUp.font;
    }
    
    [attString addAttributes:@{ NSFontAttributeName : font } range:range];
    self.m_lblSignUp.attributedText = attString;
}

# pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField isEqual:self.m_txtUserName]) {
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_USERNAME_CHARACTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    
    return YES;
}

# pragma mark - QuickBlox Handler

- (void) signinQBUser {

    [[WebService sharedInstance] signInQBUserWithUserObj:[GlobalData sharedInstance].g_selfUser
                                                 Success:^(id response) {
                                                     
                                                     DISMISS_MESSAGE;
                                                     
                                                     // register subscription for push notification
                                                     [[GlobalData sharedInstance] createQBMSubscription];
                                                     
                                                     [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                     
                                                 } Failure:^(NSString *error) {
                                                    
                                                     SHOW_ERROR_MESSAGE(error);
                                                 }];
}

- (void) registerQBUser {
    
    // signup user
    [[WebService sharedInstance] signUpQBUserWithUserObj:[GlobalData sharedInstance].g_selfUser
                                                 Success:^(id response) {
                                                     
                                                     [GlobalData sharedInstance].g_selfUser.user_qb_userid = (NSNumber *) response;
                                                     [[GlobalData sharedInstance] saveConfigData];
                                                     
                                                     // signin qb user
                                                     [self signinQBUser];
                                                     
//                                                     [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                     
                                                     
                                                 } Failure:^(NSString *error) {
                                                     
                                                     SHOW_ERROR_MESSAGE(error);
                                                 }];
}

# pragma mark - One Signal Handler

- (void) registerOSUser {
    
    // register one signal user
    if ([NSObject isValid:[GlobalData sharedInstance].g_strOSUserId] &&
        [GlobalData sharedInstance].g_strOSUserId.length > 0) {
        
        [[WebService sharedInstance] registerOneSignalUserWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                                     OneSignalUserID:[GlobalData sharedInstance].g_strOSUserId
                                                             Success:^(id response) {
                                                                 
                                                             } Failure:^(NSString *error) {
                                                                
                                                                 SHOW_ERROR_MESSAGE(error);
                                                             }];
    }
}

@end
