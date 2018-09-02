//
//  CCVIPViewController.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/24/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCVIPViewController.h"

@interface CCVIPViewController ()

@end

@implementation CCVIPViewController

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

- (IBAction)onClickContinue:(id)sender {
    
    [[IAPShare sharedHelper].iap buyProduct:[GlobalData sharedInstance].g_vipIAP.inapp_product
                               onCompletion:^(SKPaymentTransaction *transaction) {

                                   if (!transaction.error) {
                                       
                                       switch (transaction.transactionState) {
                                               
                                           case SKPaymentTransactionStatePurchased:
                                               
                                               [self didCompletePurchase];
                                               break;
                                               
                                           case SKPaymentTransactionStateFailed:
                                               
                                               [self didFailPurchase];
                                               break;
                                               
                                           case SKPaymentTransactionStateDeferred:
                                               break;
                                               
                                           case SKPaymentTransactionStateRestored:
                                               break;
                                               
                                           case SKPaymentTransactionStatePurchasing:
                                               break;
                                       }
                                   }
                               }];
}

- (IBAction)onClickBack:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SHOW_NEXT_STORY object:nil];
    [super onClickBack:sender];
}

- (IBAction)onClickRestore:(id)sender {
    
    [[IAPShare sharedHelper].iap restoreProductsWithCompletion:^(SKPaymentQueue *payment, NSError *error) {
       
        if (error) {
            
            [GlobalData sharedInstance].g_bVIPUser = NO;
        }
        else {
            
            [GlobalData sharedInstance].g_bVIPUser = YES;
        }
        
        // update vip user
        [self updateVIPUser];
    }];
}

# pragma mark - Initialize Handler

- (void) initViewController {

    // init variables
    m_nCurrentPage = 0;
    
    // set pager control
    [self setPager];
}

# pragma mark - Set Page Handler

- (void) setPager {
    
    for (NSInteger page = 0; page < self.m_vwPager.count; page ++) {
        
        UIColor *bgColor = nil;
        
        if (m_nCurrentPage == page) {
            
            switch (m_nCurrentPage) {
                
                case 0:
                    bgColor = [@"486EE7" representedColor];
                    break;
                    
                case 1:
                    bgColor = [@"EB4768" representedColor];
                    break;
                    
                case 2:
                    bgColor = [@"F39131" representedColor];
                    break;
                    
                default:
                    break;
            }
        }
        else {
            
            bgColor = [@"#CECECE" representedColor];
        }
        
        [self.m_vwPager[page] setBackgroundColor:bgColor];
    }
}

# pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    m_nCurrentPage = scrollView.contentOffset.x / CGRectGetWidth(self.view.frame);
    [self setPager];
}

# pragma mark - In App Purchase Handler

- (void) didCompletePurchase {
    
    [GlobalData sharedInstance].g_bVIPUser = YES;
    
    [[GlobalData sharedInstance] measurePurchaseEvent];
    
    [self updateVIPUser];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CONNECT_CHAT object:nil];
}

- (void) didFailPurchase {
    
    SHOW_ERROR_MESSAGE(@"Cannot purchase VIP account!");
}

# pragma mark - Update VIP User Handler

- (void) updateVIPUser {
    
    // update vip user
    [[WebService sharedInstance] updateVIPUserWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                                     VIP:@([GlobalData sharedInstance].g_bVIPUser)
                                                 Success:^(id response) {
                                                     
                                                 } Failure:^(NSString *error) {
                                                     
                                                     SHOW_ERROR_MESSAGE(error);
                                                 }];
}

@end
