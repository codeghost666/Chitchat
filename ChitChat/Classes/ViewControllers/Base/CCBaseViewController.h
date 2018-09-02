//
//  CCBaseViewController.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/13/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CCBaseViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager  *m_locationManager;
@property (nonatomic, strong) CLLocation         *m_myLocation;

- (void) trackMyLocation;

- (IBAction)onClickBack:(id)sender;

@end
