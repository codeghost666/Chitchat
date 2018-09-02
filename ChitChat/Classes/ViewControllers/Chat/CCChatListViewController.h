//
//  CCChatListViewController.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/24/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCBaseViewController.h"

@interface CCChatListViewController : CCBaseViewController {
    
    NSMutableArray *m_aryChatList;
    NSMutableArray *m_arySearch;
    
    UIRefreshControl *m_refreshControl;
    
    NSInteger m_nTotalPages;
    NSInteger m_nCurrentPage;
    
    BOOL m_bSearching;
}

@property (weak, nonatomic) IBOutlet CustomTextField *m_txtSearch;
@property (weak, nonatomic) IBOutlet UITableView *m_tblChatList;


@end
