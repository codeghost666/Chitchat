//
//  CCChatListViewController.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/24/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCChatListViewController.h"
#import "CCChatContainerViewController.h"
#import "CCChatListTableViewCell.h"

@interface CCChatListViewController ()

@end

@implementation CCChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViewController];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    [self onRefreshChatList];
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

# pragma mark - Initialize ViewController
- (void) initViewController {
    
    // init variables
    m_aryChatList   = [NSMutableArray new];
    m_arySearch     = [NSMutableArray new];
    
    m_nTotalPages   = 0;
    m_nCurrentPage  = 0;
    m_bSearching    = NO;
    
    // to set search text field delegate
    [self.m_txtSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // init table view controller
    self.m_tblChatList.rowHeight = UITableViewAutomaticDimension;
    self.m_tblChatList.estimatedRowHeight = 74;
    
    m_refreshControl = [[UIRefreshControl alloc] init];
    [m_refreshControl addTarget:self action:@selector(onRefreshChatList) forControlEvents:UIControlEventValueChanged];
    m_refreshControl.tintColor = [UIColor blackColor];
    [self.m_tblChatList addSubview:m_refreshControl];
}

- (void) onRefreshChatList {
    
    if (m_bSearching) {
     
        [m_refreshControl endRefreshing];
        return;
    }
    
    [m_aryChatList removeAllObjects];
    [m_arySearch removeAllObjects];
    m_nCurrentPage  = 0;
    m_nTotalPages   = 0;
    [self getChatList];
}

# pragma mark - Search Location Handler
- (void)textFieldDidChange:(UITextField *) sender {
    
    [self searchUsersByName:sender.text];
}

- (void) searchUsersByName:(NSString *) searchName {
    
    // empty string
    if (searchName.length == 0) {
        
        m_bSearching = NO;
        
        for (int i = 0; i < m_nTotalPages; i ++) {
            
            [m_arySearch addObjectsFromArray:m_aryChatList[i]];
        }
    }
    else {
        
        // other string
        m_bSearching = YES;
        [m_arySearch removeAllObjects];

        NSMutableArray *array = [NSMutableArray new];
        
        for (int i = 0; i < m_nTotalPages; i ++) {
            
            [array addObjectsFromArray:m_aryChatList[i]];
        }

        for(QBChatDialog *dialog in array) {
            
            if ([dialog.name rangeOfString:searchName options:NSCaseInsensitiveSearch].location != NSNotFound) {
                
                [m_arySearch addObject:dialog];
            }
        }
    }
    
    [self.m_tblChatList reloadData];
}

# pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self searchUsersByName:textField.text];
    [textField resignFirstResponder];
    
    return YES;
}

# pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    return m_arySearch.count + (m_nCurrentPage < m_nTotalPages ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!m_bSearching && m_nCurrentPage < m_nTotalPages && indexPath.row == m_arySearch.count) {
        
        UITableViewCell *cell = [self.m_tblChatList dequeueReusableCellWithIdentifier:@"UITableViewLoadMoreCell"];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewLoadMoreCell"];
        }
        
        UIActivityIndicatorView *activity = [cell viewWithTag:100];
        
        if (activity) {
            
            [activity startAnimating];
            
            [m_arySearch addObjectsFromArray:m_aryChatList[m_nCurrentPage]];
            m_nCurrentPage ++;
            [self.m_tblChatList reloadData];
        }
        
        return cell;
    }
    
    CCChatListTableViewCell* cell = [[NSBundle mainBundle] loadNibNamed:@"CCChatListTableViewCell" owner:nil options:nil][0];
    QBChatDialog *chatDialog = m_arySearch[indexPath.row];
    cell.chatDialog = chatDialog;
    
    return cell;
}

# pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CCChatContainerViewController *chatContainerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCChatContainerViewController"];
    chatContainerVC.m_chatDialog = m_arySearch[indexPath.row];
    [self.navigationController pushViewController:chatContainerVC animated:YES];
}


# pragma mark - QuickBlox Handler

- (void) getChatList {

    SHOW_WAIT_MESSAGE;
    [[WebService sharedInstance] getQBChatDialogWithUserObj:[GlobalData sharedInstance].g_selfUser
                                                    Success:^(id response) {
                                                        
                                                        DISMISS_MESSAGE;
                                                        [m_refreshControl endRefreshing];
                                                        
                                                        if (response) {
                                                            
                                                            [m_aryChatList addObject:response];
                                                            m_nTotalPages ++;
                                                        }
                                                        
                                                        [self.m_tblChatList reloadData];
                                                        
                                                    } Failure:^(NSString *error) {
                                                        
                                                        SHOW_ERROR_MESSAGE(error);
                                                    }];
}

@end
