//
//  CCSelectLocationViewController.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/15/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCBaseViewController.h"

@interface CCSelectLocationViewController : CCBaseViewController {
    
    NSMutableArray *m_aryLocations;
    NSMutableArray *m_arySearch;
}

@property (weak, nonatomic) IBOutlet CustomTextField *m_txtSearch;
@property (weak, nonatomic) IBOutlet UITableView *m_tblLocation;


@end
