//
//  CCSettingsViewController.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/18/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCSettingsViewController.h"
#import "CCInstagramActivity.h"

#import <SafariServices/SFSafariViewController.h>

#define PROMOTION_URL                       [NSURL URLWithString:@"http://52.10.49.5/app/uploads/resources/promotion.png"]
#define SHARE_DESCRIPTION                   @"\nMeet hot people nearby on Chit Chat! Get the app and start a private chat now - http://ChitChatApp.co"
#define SHARE_INSTAGRAM_DESCRIPTION         @"-\nnMeet hot people nearby on Chit Chat! Get the app and start a private chat now - http://ChitChatApp.co"


@interface CCSettingsViewController ()

@end

@implementation CCSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)onClickShare:(id)sender {
    
    // get promotion image
    [self getPromotionImage];
}

- (IBAction)onClickContactUs:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setToRecipients:@[@"support@chitchatapp.co"]];
        [mailController setSubject:@"Contact Us"];
        [mailController setMessageBody:@"See a bug?  Have a question? Want to say what’s up?  Send us an email." isHTML:YES];
        mailController.mailComposeDelegate = self;
        [self presentViewController:mailController animated:YES completion:nil];
    }
}

- (IBAction)onClickChangePreference:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                   message:@"What’s your preference?\nI like:" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *girlsAction = [UIAlertAction actionWithTitle:@"Girls" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                            // change user gender
                                                            [self changeUserGender:UserGenderFemale];
                                                        }];
    
    UIAlertAction *guysAction = [UIAlertAction actionWithTitle:@"Guys"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                          // change user gender
                                                          [self changeUserGender:UserGenderMale];
                                                      }];
    
    [alert addAction:girlsAction];
    [alert addAction:guysAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onClickTerms:(id)sender {
    
#if IPHONE_OS_VERSION_MAX_ALLOWED >= IPHONE_9_0
    
    SFSafariViewController *controller = [[SFSafariViewController alloc] initWithURL:TERMS_URL entersReaderIfAvailable:false];
    [self presentViewController:controller animated:true completion:nil];
#else
    
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:TERMS_URL];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
    
#endif
}

# pragma mark - Change User Gender Handler

- (void) changeUserGender:(UserGender) gender {
    
    SHOW_WAIT_MESSAGE;
    [[WebService sharedInstance] changeUserGenderWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                                     Gender:@(gender)
                                                    Success:^(id response) {
                                                        
                                                        DISMISS_MESSAGE;
                                                        
                                                        [GlobalData sharedInstance].g_selectedLocation = [[LocationObj alloc] init];
                                                        [GlobalData sharedInstance].g_selfUser.user_gender = @(gender);
                                                        
                                                        [[GlobalData sharedInstance] saveConfigData];
                                                        
                                                        // pop view controller
                                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                                        
                                                    } Failure:^(NSString *error) {
                                                        
                                                        SHOW_ERROR_MESSAGE(error);
                                                    }];
}

# pragma mark - MailComposeViewController Delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result) {
        case MFMailComposeResultCancelled:
            ////NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            //[SVProgressHUD showErrorWithStatus:@"You cancelled the operation and no email message was queued."];
            break;
        case MFMailComposeResultSaved:
            ////NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            //            [SVProgressHUD showSuccessWithStatus:@"You saved the email message in the drafts folder."];
            break;
        case MFMailComposeResultSent:
            ////NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            [SVProgressHUD showSuccessWithStatus:@"The email message is sent."];
            break;
        case MFMailComposeResultFailed:
            ////NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            [SVProgressHUD showErrorWithStatus:@"The email message was not saved or queued, possibly due to an error."];
            break;
        default:
            ////NSLog(@"Mail not sent.");
            [SVProgressHUD showErrorWithStatus:@"Mail not sent."];
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - Share Handler

- (void) getPromotionImage {
    
    SHOW_WAIT_MESSAGE;
    
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:PROMOTION_URL
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                // progression tracking code
                            }
                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                               
                               DISMISS_MESSAGE;
                               
                               if (image && finished) {
                                   
                                   dispatch_sync(dispatch_get_main_queue(), ^{
                                       
                                       m_imgPromotion = image;
                                   });
                               }
                               else {
                                   
                                   m_imgPromotion = [UIImage imageNamed:@"img_promotion"];
                               }
                               
                               // share promotion
                               [self showShareActivity];
                           }];
}

- (void) showShareActivity {
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://media?id=MEDIA_ID"];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        [self showInstagramActivity];
    }
    else
    {
        [self showStandardActivity];
    }
}

- (void) showInstagramActivity {
    
    CCInstagramActivity *instagramActivity = [[CCInstagramActivity alloc] init];
    instagramActivity.shareImage = m_imgPromotion;
    instagramActivity.shareString = SHARE_INSTAGRAM_DESCRIPTION;
    instagramActivity.barButtonItem = self.m_barItem;
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[m_imgPromotion, SHARE_DESCRIPTION]
                                                                                         applicationActivities:@[instagramActivity]];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePrint];
    [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
    
    [self setHandler:activityViewController];
}

- (void) showStandardActivity {
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[m_imgPromotion, SHARE_DESCRIPTION]
                                                                                         applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePrint];
    [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
    
    [self setHandler:activityViewController];
}

- (void) setHandler:(UIActivityViewController *)vcActivity {
    
    vcActivity.completionWithItemsHandler = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        
        if (completed) {
            
            NSString *strDate = [[NSDate date] formattedDateWithFormat:FORMAT_DATE];
            NSString *strShareDate = [[NSUserDefaults standardUserDefaults] stringForKey:CONFIG_KEY_SHARE_PROMOTION];
            
            if ([strShareDate isEqualToString:strDate]) {
                
                SHOW_SUCCESS_MESSAGE(@"+2 Coins! You can share 1 time each day for +2 Coins");
            }
            else {
                
                // + 2 coins
                SHOW_SUCCESS_MESSAGE(@"+2 coins");
                
                [[NSUserDefaults standardUserDefaults] setValue:strDate forKey:CONFIG_KEY_SHARE_PROMOTION];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // to update my coins
                SHOW_WAIT_MESSAGE;
                [[WebService sharedInstance] updateCoinWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                                        CoinCount:@2
                                                       UpdateType:@(UpdateCoinCountTypeInc)
                                                          Success:^(id response) {
                                                              
                                                              DISMISS_MESSAGE;
                                                              
                                                              int coin = [GlobalData sharedInstance].g_selfUser.user_coin_count.intValue + 2;
                                                              [GlobalData sharedInstance].g_selfUser.user_coin_count = @(coin);
                                                              [[GlobalData sharedInstance] saveConfigData];
                                                              
                                                          } Failure:^(NSString *error) {
                                                             
                                                              SHOW_ERROR_MESSAGE(error);
                                                          }];                
            }
        }
    };
}

#pragma mark - UIDocuments delegate

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL
                                               usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}

- (NSString *) getDirectoryPath {
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/promotion"];
    [UIImagePNGRepresentation(m_imgPromotion) writeToFile:savePath atomically:YES];
    NSString  *promotionPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/promotion"];
    
    return promotionPath;
}


@end
