//
//  CCSelectLocationViewController.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/15/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCSelectLocationViewController.h"
#import "CCLocationTableViewCell.h"


@interface CCSelectLocationViewController ()

@end

@implementation CCSelectLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViewController];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self trackMyLocation];
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

# pragma mark - Initialize Handler

- (void) initViewController {
    
    // init variables
    m_aryLocations = [NSMutableArray new];
    m_arySearch = [NSMutableArray new];
    
    // to set search text field delegate
    [self.m_txtSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // add notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_GET_MY_LOCATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetMyLocation) name:NOTI_GET_MY_LOCATION object:nil];
}

# pragma mark - Notification Handler

- (void) didGetMyLocation {
    
    // get near by search
    [self getNearBySearch];
}

# pragma mark - Get Near By User Gender

- (void) getNearBySearch {

    SHOW_WAIT_MESSAGE;
    [[WebService sharedInstance] getNearBySearchWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                                    Gender:[GlobalData sharedInstance].g_selfUser.user_gender
                                                  DeviceID:[GlobalData sharedInstance].g_strDeviceID
                                               DeviceToken:[GlobalData sharedInstance].g_strDeviceToken
                                                  Latitude:@(self.m_myLocation.coordinate.latitude)
                                                 Longitude:@(self.m_myLocation.coordinate.longitude)
                                                   Success:^(id response) {
                                                       
                                                       DISMISS_MESSAGE;
                                                       
                                                       NSDictionary *dictResult = (NSDictionary *) response;
                                                       
                                                       // check valid user
                                                       if ([NSObject isValid:dictResult[@"user"]]) {
                                                           
                                                           [GlobalData sharedInstance].g_selfUser = [UserObj instanceWithDict:dictResult[@"user"]];
                                                           [[GlobalData sharedInstance] saveConfigData];
                                                           
                                                           // get location list
                                                           [m_aryLocations removeAllObjects];
                                                           for (NSDictionary *dict in dictResult[@"location_list"]) {
                                                               
                                                               LocationObj *locationObj = [LocationObj instanceWithDict:dict];
                                                               [m_aryLocations addObject:locationObj];
                                                           }
                                                           [m_arySearch setArray:m_aryLocations];
                                                           
                                                           // reload data
                                                           [self.m_tblLocation reloadData];
                                                       }
                                                       else {
                                                           
                                                           NSString *message = @"Your account is not actived.\nPlease contact administrator.";
                                                           
                                                           UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                                                                          message:message
                                                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                                                           
                                                           UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay"
                                                                                                              style:UIAlertActionStyleCancel
                                                                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                                                                
                                                                                                                [GlobalData sharedInstance].g_selfUser = [[UserObj alloc] init];
                                                                                                                [[GlobalData sharedInstance] saveConfigData];
                                                                                                                
                                                                                                                [self.navigationController popViewControllerAnimated:NO];
                                                                                                            }];
                                                           
                                                           [alert addAction:okAction];
                                                           [self presentViewController:alert animated:YES completion:nil];

                                                       }
                                                       
                                                       
                                                   } Failure:^(NSString *error) {
                                                      
                                                       SHOW_ERROR_MESSAGE(error);
                                                   }];
}

# pragma mark - Search Location Handler
- (void)textFieldDidChange:(UITextField *) sender {
    
    [self searchUsersByName:sender.text];
}

- (void) searchUsersByName:(NSString *) searchName {
    
    // empty string
    if (searchName.length == 0) {
        
        [m_arySearch setArray:m_aryLocations];
    }
    else {
        
        // other string
        [m_arySearch removeAllObjects];
        
        for(LocationObj *locationObj in m_aryLocations) {
            
            if ([locationObj.location_name rangeOfString:searchName options:NSCaseInsensitiveSearch].location != NSNotFound) {
                
                [m_arySearch addObject:locationObj];
            }
        }
    }
    
    [self.m_tblLocation reloadData];
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
    
    return m_arySearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"CCLocationTableViewCell";
    
    CCLocationTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.locationObj = (LocationObj *) m_arySearch[indexPath.row];
    
    return cell;
}

# pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // save selected location
    [GlobalData sharedInstance].g_selectedLocation = (LocationObj *) m_arySearch[indexPath.row];
    [[GlobalData sharedInstance] saveConfigData];
    
    // go to home screen
    UIViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCHomeViewController"];
    [self.navigationController pushViewController:homeVC animated:YES];
}

@end
