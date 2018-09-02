//
//  CCNotificationViewController.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/18/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCBaseViewController.h"

@interface CCNotificationViewController : CCBaseViewController {
    
    NSMutableArray  * m_aryNotifications;
}

@property (weak, nonatomic) IBOutlet UITableView *m_tblNotification;

@end
