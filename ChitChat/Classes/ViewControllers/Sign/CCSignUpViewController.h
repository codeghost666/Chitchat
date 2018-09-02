//
//  CCSignUpViewController.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/13/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCBaseViewController.h"

@interface CCSignUpViewController : CCBaseViewController

@property (weak, nonatomic) IBOutlet CustomTextField *m_txtUserName;
@property (weak, nonatomic) IBOutlet CustomTextField *m_txtPassword;
@property (weak, nonatomic) IBOutlet CustomTextField *m_txtUserEmail;
@property (weak, nonatomic) IBOutlet UILabel *m_lblSignIn;
@property (weak, nonatomic) IBOutlet UIView *m_vwGenderView;
@property (retain, nonatomic) NYSegmentedControl *m_segGender;
@property (weak, nonatomic) IBOutlet ResponsiveLabel *m_lblTerms;


- (IBAction)onClickNext:(id)sender;
- (IBAction)onClickSignIn:(id)sender;

@end
