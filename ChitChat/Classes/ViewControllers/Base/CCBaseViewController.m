//
//  CCBaseViewController.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/13/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCBaseViewController.h"

@interface CCBaseViewController ()

@end

@implementation CCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
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

# pragma mark - Event Handler
- (IBAction)onClickBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


# pragma mark - Track User Location Handler
- (void) trackMyLocation {
    
    if (!self.m_locationManager) {
     
        self.m_locationManager = [[CLLocationManager alloc] init];

        [self.m_locationManager requestWhenInUseAuthorization];
        self.m_locationManager.delegate = self;
        self.m_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    [self.m_locationManager startUpdatingLocation];
    
    if (!self.m_myLocation) {
        
        self.m_myLocation = [[CLLocation alloc] initWithLatitude:0.0f longitude:0.0f];
    }
}


# pragma mark - CLLocation Manager Delegate Method

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    self.m_myLocation = [[CLLocation alloc] initWithLatitude:0.0f longitude:0.0f];
    [self.m_locationManager stopUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_GET_MY_LOCATION object:nil];
    
/*    UIAlertController* alert = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                   message:@"We need your location to use ChitChat!\nGo to Settings > ChitChat > Location > While using"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        _exit(0);
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        // send notification
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_GET_MY_LOCATION object:nil];
    }];

    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];*/
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.m_myLocation = (CLLocation *)[locations lastObject];
    
    if (self.m_myLocation) {
        
        [self.m_locationManager stopUpdatingLocation];
        
        NSLog(@"%f, %f", self.m_myLocation.coordinate.latitude, self.m_myLocation.coordinate.longitude);
        
        // send notification
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_GET_MY_LOCATION object:nil];
    }
}

@end
