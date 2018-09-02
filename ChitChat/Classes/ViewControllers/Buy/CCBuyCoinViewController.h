//
//  CCBuyCoinViewController.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/21/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCBaseViewController.h"

@interface CCBuyCoinViewController : CCBaseViewController {
    
    NSMutableArray *m_aryCoins;
    NSArray *m_aryProducts;
    NSMutableArray *m_arySaves;
    
    NSInteger m_nSelectedIndex;
}

@property (weak, nonatomic) IBOutlet UICollectionView *m_collectionView;

- (IBAction)onClickBuy:(id)sender;

@end
