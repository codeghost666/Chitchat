//
//  CCSettingsViewController.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/18/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCBaseViewController.h"
#import <MessageUI/MessageUI.h>

@interface CCSettingsViewController : CCBaseViewController<MFMailComposeViewControllerDelegate> {
    
    UIImage *m_imgPromotion;
    UIDocumentInteractionController *m_documentController;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *m_barItem;

- (IBAction)onClickShare:(id)sender;
- (IBAction)onClickContactUs:(id)sender;
- (IBAction)onClickChangePreference:(id)sender;
- (IBAction)onClickTerms:(id)sender;


@end
