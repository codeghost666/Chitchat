//
//  CCVIPViewController.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/24/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCBaseViewController.h"

@interface CCVIPViewController : CCBaseViewController {
    
    NSInteger m_nCurrentPage;
}

@property (strong, nonatomic) IBOutletCollection(CustomView) NSArray *m_vwPager;

- (IBAction)onClickContinue:(id)sender;
- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickRestore:(id)sender;


@end
