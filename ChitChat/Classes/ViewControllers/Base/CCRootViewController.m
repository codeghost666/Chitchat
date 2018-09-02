//
//  CCRootViewController.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/13/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCRootViewController.h"

@interface CCRootViewController ()

@end

@implementation CCRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set rate popup
    NSInteger nLaunched = [[NSUserDefaults standardUserDefaults] integerForKey:CONFIG_KEY_LAUNCHED];
    
    if (nLaunched == 1) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                       message:@"Like Chit Chat? Leave a 5 star review"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             [[NSUserDefaults standardUserDefaults] setInteger:nLaunched + 1 forKey:CONFIG_KEY_LAUNCHED];
                                                             [[NSUserDefaults standardUserDefaults] synchronize];
                                                             
                                                             [self setInitViewController];
                                                         }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             [[NSUserDefaults standardUserDefaults] setInteger:nLaunched + 1 forKey:CONFIG_KEY_LAUNCHED];
                                                             [[NSUserDefaults standardUserDefaults] synchronize];
                                                             
                                                             [self setInitViewController];
                                                             
                                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://follow-bro.com/chitchat"]];
                                                         }];

        [alert addAction:noAction];
        [alert addAction:okAction];
        UIViewController *vc = [UIViewController currentViewController];
        [vc presentViewController:alert animated:YES completion:nil];
    }
    else if (nLaunched < 1) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:nLaunched + 1 forKey:CONFIG_KEY_LAUNCHED];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setInitViewController];
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

# pragma mark - Inititlaize Handler

- (void) setInitViewController {
    
    if ([GlobalData sharedInstance].g_selfUser.user_id.intValue > 0) {
        
        if ([GlobalData sharedInstance].g_selectedLocation.location_id.intValue > 0) {

            UIViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCHomeViewController"];
            [self.navigationController pushViewController:homeVC animated:NO];
        }
        else {
            
            UIViewController *selectVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCSelectLocationViewController"];
            [self.navigationController pushViewController:selectVC animated:NO];
        }
    }
    else {
        
        // track my location
        [self trackMyLocation];
        
        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCSignNavController"];
        [self.navigationController presentViewController:navVC animated:NO completion:nil];
    }
}

@end
