//
//  CCExploreViewController.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/18/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCBaseViewController.h"

@interface CCExploreViewController : CCBaseViewController {
    
    NSMutableArray *m_aryData;
    NSMutableArray *m_arySearch;
}

@property (weak, nonatomic) IBOutlet CustomTextField *m_txtSearch;
@property (weak, nonatomic) IBOutlet UITableView *m_tblExplore;

@end
