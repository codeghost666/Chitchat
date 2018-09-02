//
//  CCBuyCoinCollectionViewCell.h
//  ChitChat
//
//  Created by Jinjin Lee on 11/7/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BuyCellType) {
    
    BuyCellTypeNone = 0,
    BuyCellTypeMostPopular,
    BuyCellTypeSelect,
};

@interface CCBuyCoinCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *m_ivSelection;
@property (weak, nonatomic) IBOutlet UILabel *m_lblCoins;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPrice;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivCoins;
@property (weak, nonatomic) IBOutlet UILabel *m_lblSave;

@property (retain, nonatomic) IAPObj *iapObj;
@property (assign, nonatomic) BuyCellType cellType;

@end
