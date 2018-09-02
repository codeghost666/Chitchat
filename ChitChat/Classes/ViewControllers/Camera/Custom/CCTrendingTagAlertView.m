//
//  CCTrendingTagAlertView.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/22/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCTrendingTagAlertView.h"
#import "CCTrendingAlertTableViewCell.h"

@implementation CCTrendingTagAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)onClickSubmit:(id)sender {

    if ([NSObject isValid:trendig_tag]) {
        
        if ([self.delegate respondsToSelector:@selector(didClickSubmit:)])
            [self.delegate didClickSubmit:trendig_tag];
    }
    else {
        
        SHOW_ERROR_MESSAGE(@"Please select trending tag!");
    }
}

- (IBAction)onClickClose:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickClose)])
        [self.delegate didClickClose];
}

# pragma mark - Set Trending Tags Handler

- (void) setTrendingTags:(NSArray *)trendingTags {
    
    _trendingTags = trendingTags;
    [self.m_tblTrendingTag reloadData];
}

# pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [NSObject isValid:self.trendingTags] ? self.trendingTags.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCTrendingAlertTableViewCell* cell = [[NSBundle mainBundle] loadNibNamed:@"CCTrendingAlertTableViewCell" owner:nil options:nil][0];
    cell.trendingTag = self.trendingTags[indexPath.row];
    
    return cell;
}

# pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // check vip
    if (indexPath.row == 0) {
        
        // check current coins
        if ([GlobalData sharedInstance].g_selfUser.user_coin_count.intValue < VIP_COIN_COUNT) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                           message:@"Get your story featured for 90 credits!\nGet more credits now."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     
                                                                 }];
            
            UIAlertAction *buyAction = [UIAlertAction actionWithTitle:@"Buy Credits"
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  
                                                                  [self gotoBuyCoinViewController];
                                                              }];
            
            [alert addAction:cancelAction];
            [alert addAction:buyAction];
            
            [self.parentVC presentViewController:alert animated:YES completion:nil];
            
            return;
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                       message:@"Do you want your story to be featured for 90 credits?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 
                                                             }];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                              for (NSInteger i = 0; i < self.trendingTags.count; i ++) {
                                                                  
                                                                  CCTrendingAlertTableViewCell *cell = (CCTrendingAlertTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                                                                  
                                                                  if (i == indexPath.row) {
                                                                      
                                                                      [cell selectCell:YES];
                                                                      trendig_tag = cell.trendingTag;
                                                                      
                                                                      [self onClickSubmit:nil];
                                                                  }
                                                                  else {
                                                                      [cell selectCell:NO];
                                                                  }
                                                              }
                                                          }];
        
        [alert addAction:cancelAction];
        [alert addAction:yesAction];
        
        [self.parentVC presentViewController:alert animated:YES completion:nil];
    }
    else {
        
        for (NSInteger i = 0; i < self.trendingTags.count; i ++) {
            
            CCTrendingAlertTableViewCell *cell = (CCTrendingAlertTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            if (i == indexPath.row) {
                
                [cell selectCell:YES];
                trendig_tag = cell.trendingTag;
            }
            else {
                [cell selectCell:NO];
            }
        }
    }
}

# pragma mark - Go to Buy View Controller Handler
- (void) gotoBuyCoinViewController {
    
    UIViewController *buyCoinVC = [self.parentVC.storyboard instantiateViewControllerWithIdentifier:@"CCBuyCoinViewController"];
    [self.parentVC.navigationController pushViewController:buyCoinVC animated:YES];
}


@end
