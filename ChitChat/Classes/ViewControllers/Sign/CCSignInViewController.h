//
//  CCSignInViewController.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/13/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCBaseViewController.h"

@interface CCSignInViewController : CCBaseViewController

@property (weak, nonatomic) IBOutlet CustomTextField *m_txtUserName;
@property (weak, nonatomic) IBOutlet CustomTextField *m_txtPassword;
@property (weak, nonatomic) IBOutlet UILabel *m_lblSignUp;

- (IBAction)onClickNext:(id)sender;
- (IBAction)onClickSignUp:(id)sender;


@end
