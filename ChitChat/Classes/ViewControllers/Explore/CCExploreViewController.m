//
//  CCExploreViewController.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/18/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCExploreViewController.h"
#import "CCHomeTableViewCell.h"
#import "CCWatchViewController.h"

@interface CCExploreViewController ()

@end

@implementation CCExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViewController];
    
    [self exploreLocations];
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
    m_aryData = [NSMutableArray new];
    m_arySearch = [NSMutableArray new];
    
    // init search text field handler
    [self.m_txtSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

# pragma mark - Explore Locations Handler

- (void) exploreLocations {
    
    SHOW_WAIT_MESSAGE;
    [[WebService sharedInstance] exploreLocationWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                                    Gender:[GlobalData sharedInstance].g_selfUser.user_gender
                                                  Latitude:[GlobalData sharedInstance].g_selfUser.user_lat
                                                 Longitude:[GlobalData sharedInstance].g_selfUser.user_long
                                                   Success:^(id response) {
                                                       
                                                       DISMISS_MESSAGE;
                                                       
                                                       // set data
                                                       [m_aryData removeAllObjects];
                                                       [m_aryData setArray:(NSArray *) response];
                                                       [m_arySearch setArray:m_aryData];
                                                       
                                                       // reload data
                                                       [self.m_tblExplore reloadData];
                                                       
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
        
        [m_arySearch setArray:m_aryData];
    }
    else {
        
        // other string
        [m_arySearch removeAllObjects];
        
        for(LocationObj *locationObj in m_aryData) {
            
            if ([locationObj.location_name rangeOfString:searchName options:NSCaseInsensitiveSearch].location != NSNotFound) {
                
                [m_arySearch addObject:locationObj];
            }
        }
    }
    
    [self.m_tblExplore reloadData];
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
    
    CCHomeTableViewCell* cell = [[NSBundle mainBundle] loadNibNamed:@"CCHomeTableViewCell" owner:nil options:nil][0];
    LocationObj *locationObj = m_arySearch[indexPath.row];
    cell.locationObj = locationObj;
    
    return cell;
}

# pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self saveLocationWithLocationObj:m_arySearch[indexPath.row]];
}

# pragma mark - Save Location Handler

- (void) saveLocationWithLocationObj:(LocationObj *) locationObj {
    
    if (![NSObject isValid:locationObj]
        || [locationObj.location_place_id isEqualToString:@""]
        || [locationObj.location_name isEqualToString:@""]
        || locationObj.location_type.intValue == LocationTypeNone) {
        
        SHOW_ERROR_MESSAGE(@"Please select valid location to watch story.");
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    SHOW_WAIT_MESSAGE;
    [[WebService sharedInstance] saveLocationWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                         LocationObject:locationObj
                                                Success:^(id response) {
                                                    
                                                    DISMISS_MESSAGE;
                                                    
                                                    NSDictionary *dictResult = (NSDictionary *) response;
                                                    
                                                    // check valid user
                                                    if (![NSObject isValid:dictResult[@"user"]]) {
                                                        
                                                        NSString *message = @"Your account is not actived.\nPlease contact administrator.";
                                                        
                                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                                                                       message:message
                                                                                                                preferredStyle:UIAlertControllerStyleAlert];
                                                        
                                                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay"
                                                                                                           style:UIAlertActionStyleCancel
                                                                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                                                             
                                                                                                             [GlobalData sharedInstance].g_selfUser = [[UserObj alloc] init];
                                                                                                             [GlobalData sharedInstance].g_selectedLocation = [[LocationObj alloc] init];
                                                                                                             [[GlobalData sharedInstance] saveConfigData];
                                                                                                             
                                                                                                             [self.navigationController popToRootViewControllerAnimated:NO];
                                                                                                         }];
                                                        
                                                        [alert addAction:okAction];
                                                        [self presentViewController:alert animated:YES completion:nil];
                                                    }
                                                    else {  // valid user
                                                        
                                                        // save user profile
                                                        [GlobalData sharedInstance].g_selfUser = [UserObj instanceWithDict:dictResult[@"user"]];
                                                        [[GlobalData sharedInstance] saveConfigData];
                                                        
                                                        // save my location
                                                        LocationObj *selectedLocation = [LocationObj instanceWithDict:dictResult[@"location"]];
                                                        
                                                        // go to watch view controller
                                                        [self watchStoryWithLocation:selectedLocation];
                                                    }
                                                    
                                                } Failure:^(NSString *error) {
                                                    
                                                    SHOW_ERROR_MESSAGE(error);
                                                }];
}


# pragma mark - Watch Story Handler

- (void) watchStoryWithLocation:(LocationObj *) locationObj {

    CCWatchViewController *watchViewController = (CCWatchViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CCWatchViewController"];
    watchViewController.m_locationObj = locationObj;
    [self.navigationController pushViewController:watchViewController animated:YES];
}

@end
