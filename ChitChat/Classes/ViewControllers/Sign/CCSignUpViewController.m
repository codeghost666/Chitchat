//
//  CCSignUpViewController.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/13/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCSignUpViewController.h"
#import <SafariServices/SFSafariViewController.h>

@interface CCSignUpViewController ()

@end

@implementation CCSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViewController];
}

- (void) viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [self.view layoutIfNeeded];
    
    if (!self.m_segGender) {
        
        self.m_segGender = [[NYSegmentedControl alloc] initWithItems:@[@"Male", @"Female"]];
        self.m_segGender.titleFont = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:14.0f];
        self.m_segGender.titleTextColor = [@"#fefefe33" representedColor];
        self.m_segGender.selectedTitleFont = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:14.0f];
        self.m_segGender.selectedTitleTextColor = [@"#dfdfdf" representedColor];
        self.m_segGender.borderWidth = 0.0f;
        self.m_segGender.drawsGradientBackground = NO;
        self.m_segGender.segmentIndicatorInset = 0.0f;
        self.m_segGender.drawsSegmentIndicatorGradientBackground = NO;
        self.m_segGender.segmentIndicatorBorderWidth = 0.0f;
        self.m_segGender.segmentIndicatorBackgroundColor = [@"#fefefe33" representedColor];
        self.m_segGender.backgroundColor = [UIColor clearColor];
        [self.m_segGender setFrame:CGRectMake(0, 0, CGRectGetWidth(self.m_vwGenderView.frame), CGRectGetHeight(self.m_vwGenderView.frame))];
        [self.m_vwGenderView addSubview:self.m_segGender];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.m_segGender.selectedSegmentIndex = 1;
    self.m_segGender.selectedSegmentIndex = 0;
    self.m_segGender.segmentIndicatorAnimationDuration = 0.3f;
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
    
    // hide keyboard
    [self.m_txtUserName resignFirstResponder];
    [self.m_txtPassword resignFirstResponder];
    [self.m_txtUserEmail resignFirstResponder];
    
    // trim strings
    self.m_txtUserName.text = [self.m_txtUserName.text trim];
    self.m_txtUserEmail.text = [self.m_txtUserEmail.text trim];
    
    // check validation
    if (![self.m_txtUserName isValidText]) {
        
        SHOW_ERROR_MESSAGE(@"Invalid user name!");
    }
    else if ([self.m_txtUserName.text containsString:@" "]) {
        
        SHOW_ERROR_MESSAGE(@"User name cannot contain blank character!");
    }
    else if (![self.m_txtPassword isValidText]) {
        
        SHOW_ERROR_MESSAGE(@"Invalid password!");
    }
    else if (![self.m_txtUserEmail isValidText]) {
        
        SHOW_ERROR_MESSAGE(@"Invalid email!");
    }
    else {
        
        // set user object
        UserObj *userObj = [[UserObj alloc] init];
        
        userObj.user_name           = self.m_txtUserName.text;
        userObj.user_email          = self.m_txtUserEmail.text;
        userObj.user_password       = self.m_txtPassword.text;
        userObj.user_gender         = @(self.m_segGender.selectedSegmentIndex);
        userObj.user_lat            = @(self.m_myLocation.coordinate.latitude);
        userObj.user_long           = @(self.m_myLocation.coordinate.longitude);
        userObj.user_device_id      = [GlobalData sharedInstance].g_strDeviceID;
        userObj.user_device_token   = [GlobalData sharedInstance].g_strDeviceToken;
        
        SHOW_WAIT_MESSAGE;
        [[WebService sharedInstance] signupWithUserObj:userObj
                                               Success:^(id response) {
                                                   
                                                   [SVProgressHUD showWithStatus:@"Processing signup..."];
                                                   
                                                   [GlobalData sharedInstance].g_selfUser = (UserObj *) response;
                                                   
                                                   [self registerQBUser];
                                                   
                                                   [self registerOSUser];
                                                   
                                               } Failure:^(NSString *error) {
                                                   
                                                   SHOW_ERROR_MESSAGE(error);
                                               }];
    }
}

- (IBAction)onClickSignIn:(id)sender {
    
    UIViewController *signinVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCSignInViewController"];
    [self.navigationController pushViewController:signinVC animated:YES];
}


# pragma mark - Initialize Handler

- (void) initViewController {
    
    // init text fields
    self.m_txtUserName.textFieldStyle = CustomTextFieldStyleDefault;
    self.m_txtPassword.textFieldStyle = CustomTextFieldStyleSecure;
    self.m_txtUserEmail.textFieldStyle = CustomTextFieldStyleEmail;
    
    self.m_txtUserName.tintColor = [UIColor whiteColor];
    self.m_txtPassword.tintColor = [UIColor whiteColor];
    self.m_txtUserEmail.tintColor = [UIColor whiteColor];
    
    
    // init label
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self.m_lblSignIn.text];
    NSRange range = [self.m_lblSignIn.text rangeOfString:@"Sign In"];
    
    UIFont *font = [UIFont fontWithName:@"AvenirNextLTPro-Bold" size:self.m_lblSignIn.font.pointSize];
    if (![NSObject isValid:font]) {
        
        font = self.m_lblSignIn.font;
    }
    
    [attString addAttributes:@{ NSFontAttributeName : font } range:range];
    self.m_lblSignIn.attributedText = attString;
    
    // init terms
    self.m_lblTerms.userInteractionEnabled = YES;
    PatternTapResponder stringTapAction = ^(NSString *tappedString) {
        
#if IPHONE_OS_VERSION_MAX_ALLOWED >= IPHONE_9_0
        
        SFSafariViewController *controller = [[SFSafariViewController alloc] initWithURL:TERMS_URL entersReaderIfAvailable:false];
        [self presentViewController:controller animated:true completion:nil];
#else
        
        TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:TERMS_URL];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
        
#endif
    };
    
    [self.m_lblTerms enableStringDetection:@"Terms"
                            withAttributes:@{RLTapResponderAttributeName: stringTapAction,
                                             NSFontAttributeName:[UIFont fontWithName:@"AvenirNextLTPro-Bold" size:14.0f],
                                             NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    
    [self.m_lblTerms enableStringDetection:@"Chit Chat"
                            withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNextLTPro-Bold" size:14.0f]}];
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

- (void) registerQBUser {
    
    // signup user
    [[WebService sharedInstance] signUpQBUserWithUserObj:[GlobalData sharedInstance].g_selfUser
                                                 Success:^(id response) {
                                                     
                                                     DISMISS_MESSAGE;
                                                     
                                                     [GlobalData sharedInstance].g_selfUser.user_qb_userid = (NSNumber *) response;
                                                     [[GlobalData sharedInstance] saveConfigData];
                                                     
                                                     // register subscription for push notification
                                                     [[GlobalData sharedInstance] createQBMSubscription];
                                                     
                                                     // register event
                                                     [self measureTuneRegisterEvent];
                                                     
                                                     [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                     
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

# pragma mark - Tune for MAT Handler
- (void) measureTuneRegisterEvent {
    
    if ([GlobalData sharedInstance].g_selfUser.user_gender.integerValue == UserGenderMale) {
        
        [Tune setUserEmail:[GlobalData sharedInstance].g_selfUser.user_email];
        [Tune setUserName:[GlobalData sharedInstance].g_selfUser.user_name];
        [Tune setGender:TuneGenderMale];
        [Tune setUserId:[[GlobalData sharedInstance].g_selfUser.user_id stringValue]];
        TuneLocation *loc = [TuneLocation new];
        loc.latitude = [GlobalData sharedInstance].g_selfUser.user_lat;
        loc.longitude = [GlobalData sharedInstance].g_selfUser.user_long;
        [Tune setLocation:loc];
        [Tune measureEventName:TUNE_EVENT_REGISTRATION];
    }
}

@end
