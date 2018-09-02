//
//  CCBuyCoinViewController.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/21/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCBuyCoinViewController.h"
#import "CCBuyCoinCollectionViewCell.h"

@interface CCBuyCoinViewController ()

@end

@implementation CCBuyCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViewController];
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

# pragma mark - Event Handler

- (IBAction)onClickBuy:(id)sender {
    
    if ([[GlobalData sharedInstance] isJailbrokenPhone]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                       message:@"Jailbroken phone error, can’t buy more."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             _exit(0);
                                                         }];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    IAPObj *iapObj = m_aryCoins[m_nSelectedIndex];
    if (!iapObj.inapp_product) {
        
        SHOW_ERROR_MESSAGE(@"Could not get this product!");
        return;
    }
    
    // buy product
    SHOW_WAIT_MESSAGE;
    [[IAPShare sharedHelper].iap buyProduct:iapObj.inapp_product
                               onCompletion:^(SKPaymentTransaction *transaction) {
                                   
                                   if (transaction.error) {
                                       
                                       [SVProgressHUD showErrorWithStatus:transaction.error.localizedDescription];
                                   }
                                   else {
                                       
                                       switch (transaction.transactionState) {
                                               
                                           case SKPaymentTransactionStatePurchased:
                                               
                                               [self didCompletedBuyCoins];
                                               break;
                                               
                                           case SKPaymentTransactionStateFailed:
                                               
                                               [self didFailedTransaction];
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

# pragma mark - Initialize Handler

- (void) initViewController {
    
    // init variables
    m_aryCoins = [NSMutableArray new];
    [m_aryCoins setArray:[GlobalData sharedInstance].g_aryInApps];
    
    m_nSelectedIndex = 0;

    // set save value
    CGFloat maxValue = 0.0f;
    for (NSInteger i = 0; i < m_aryCoins.count; i ++) {
        
        IAPObj *iapObj = m_aryCoins[i];
        CGFloat value = iapObj.inapp_price.floatValue / iapObj.inapp_coins.floatValue;
        maxValue = maxValue < value ? value : maxValue;
    }

    for (NSInteger i = 0; i < m_aryCoins.count; i ++) {
        
        IAPObj *iapObj = m_aryCoins[i];
        CGFloat value = iapObj.inapp_price.floatValue / iapObj.inapp_coins.floatValue;
        iapObj.inapp_save_value = @((1 - round(value / maxValue * 100) / 100) * 100);
    }
}

# pragma mark - Get Buy coins

- (void) getBuyCoins {
    
    SHOW_WAIT_MESSAGE;
    [[WebService sharedInstance] getInAppDataWithSuccess:^(id response) {
        
        DISMISS_MESSAGE;
        
        NSDictionary *dictResult = (NSDictionary *) response;
        for (NSDictionary *dict in dictResult[@"buycoins"]) {
            
            [m_aryCoins addObject:[IAPObj instanceWithDict:dict]];
        }

    } Failure:^(NSString *error) {
       
        SHOW_ERROR_MESSAGE(error);
    }];
}

# pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat size = CGRectGetWidth(self.view.frame) / 2 - 15;
    return CGSizeMake(size, size * 0.9f);
}

#pragma mark - UICollectionView DataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CCBuyCoinCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCBuyCoinCollectionViewCell" forIndexPath:indexPath];
    
    cell.iapObj = m_aryCoins[indexPath.item];
    
    if (m_nSelectedIndex == indexPath.item) {
        
        cell.cellType = m_nSelectedIndex == 0 ? BuyCellTypeMostPopular : BuyCellTypeSelect;
    }
    else {
        
        cell.cellType = BuyCellTypeNone;
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return m_aryCoins.count;
}

# pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    m_nSelectedIndex = indexPath.item;
    [self onClickBuy:nil];
    
    [self.m_collectionView reloadData];
}

# pragma mark - IAPManager Delegate
- (void) didCompletedBuyCoins {
    
    [self setBuyCoinToServer];
    
/*    IAPObj *iapObj = m_aryCoins[m_nSelectedIndex];
    [[WebService sharedInstance] updateCoinWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                            CoinCount:iapObj.inapp_coins
                                           UpdateType:@(UpdateCoinCountTypeInc)
                                              Success:^(id response) {
                                                  
                                                  // set user coin count
                                                  int coins = [GlobalData sharedInstance].g_selfUser.user_coin_count.intValue + iapObj.inapp_coins.intValue;
                                                  [GlobalData sharedInstance].g_selfUser.user_coin_count = @(coins);
                                                  
                                                  // set label of buy coin view controller
                                                  NSString *strMsg = [NSString stringWithFormat:@"You just got %@ credits!", iapObj.inapp_coins.stringValue];
                                                  
                                                  [SVProgressHUD showSuccessWithStatus:strMsg];
                                                  
                                                  
                                              } Failure:^(NSString *error) {
                                                  
                                                  SHOW_ERROR_MESSAGE(error);
                                              }];*/
    
}

- (void) didFailedTransaction {
    
    [SVProgressHUD showErrorWithStatus:@"Failed getting more coins!"];
}

# pragma mark - Save User Coin
- (void) setBuyCoinToServer {
    
    IAPObj *iapObj = m_aryCoins[m_nSelectedIndex];
    [[WebService sharedInstance] buyCoinWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                         CoinCount:iapObj.inapp_coins
                                             Price:iapObj.inapp_price
                                           Success:^(id response) {
                                               
                                               // set user coin count
                                               int coins = [GlobalData sharedInstance].g_selfUser.user_coin_count.intValue + iapObj.inapp_coins.intValue;
                                               [GlobalData sharedInstance].g_selfUser.user_coin_count = @(coins);
                                               
                                               // set label of buy coin view controller
                                               NSString *strMsg = [NSString stringWithFormat:@"You just got %@ credits!", iapObj.inapp_coins.stringValue];
                                               [SVProgressHUD showSuccessWithStatus:strMsg];
                                               
                                               
                                           } Failure:^(NSString *error) {
                                               
                                               SHOW_ERROR_MESSAGE(error);
                                           }];
}

@end
