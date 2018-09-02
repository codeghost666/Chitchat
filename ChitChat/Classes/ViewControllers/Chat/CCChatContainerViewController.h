//
//  CCChatContainerViewController.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/28/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCBaseViewController.h"

@interface CCChatContainerViewController : CCBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (weak, nonatomic) IBOutlet UIView *m_vwMain;

@property (retain, nonatomic) QBChatDialog *m_chatDialog;

- (IBAction)onClickBlockUser:(id)sender;

@end
