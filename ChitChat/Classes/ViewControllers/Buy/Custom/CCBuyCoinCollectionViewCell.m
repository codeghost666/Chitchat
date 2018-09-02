//
//  CCBuyCoinCollectionViewCell.m
//  ChitChat
//
//  Created by Jinjin Lee on 11/7/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCBuyCoinCollectionViewCell.h"

@implementation CCBuyCoinCollectionViewCell

- (void) setIapObj:(IAPObj *)iapObj {

    _iapObj = iapObj;
    
    // set coins
    self.m_lblCoins.text = [NSString stringWithFormat:@"%@ credits", iapObj.inapp_coins.stringValue];
    
    // set price
    self.m_lblPrice.text = [NSString stringWithFormat:@"Payment of $%.2f", iapObj.inapp_price.floatValue];
    
    // set icon
    [self.m_ivCoins sd_setImageWithURL:[NSURL URLWithString:iapObj.inapp_icons]];
    
    // set save value
    self.m_lblSave.text = [NSString stringWithFormat:@"Save %ld%%", (long)iapObj.inapp_save_value.integerValue];
    self.m_lblSave.hidden = iapObj.inapp_save_value.integerValue == 0;
    
    // set select icon
    self.m_ivSelection.image = [UIImage imageNamed:@"ic_buy_normal"];
}

- (void) setCellType:(BuyCellType)cellType {
    
    switch (cellType) {
        case BuyCellTypeNone:
            self.m_ivSelection.image = [UIImage imageNamed:@"ic_buy_normal"];
            break;
            
        case BuyCellTypeMostPopular:
            self.m_ivSelection.image = [UIImage imageNamed:@"ic_mostpopular"];
            break;
            
        case BuyCellTypeSelect:
            self.m_ivSelection.image = [UIImage imageNamed:@"box_choosen"];
            break;
            
        default:
            break;
    }
    
    _cellType = cellType;
}

@end
