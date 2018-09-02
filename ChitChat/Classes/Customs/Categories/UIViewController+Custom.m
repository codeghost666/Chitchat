//
//  UIViewController+Custom.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/28/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "UIViewController+Custom.h"

@implementation UIViewController (Custom)

+ (UIViewController *) currentViewController {
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findTopViewController:rootVC];
}

+ (UIViewController *) findTopViewController:(UIViewController *) rootViewController {
    
    if (rootViewController.presentedViewController) {
        
        // Return presented view controller
        return [UIViewController findTopViewController:rootViewController.presentedViewController];
        
    } else if ([rootViewController isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) rootViewController;
        if (svc.viewControllers.count > 0)
            return [UIViewController findTopViewController:svc.viewControllers.lastObject];
        else
            return rootViewController;
        
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) rootViewController;
        if (svc.viewControllers.count > 0)
            return [UIViewController findTopViewController:svc.topViewController];
        else
            return rootViewController;
        
    } else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) rootViewController;
        if (svc.viewControllers.count > 0)
            return [UIViewController findTopViewController:svc.selectedViewController];
        else
            return rootViewController;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return rootViewController;
    }
}

@end
