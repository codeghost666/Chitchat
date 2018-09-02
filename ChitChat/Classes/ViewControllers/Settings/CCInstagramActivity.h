//
//  CCInstagramActivity.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/18/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCInstagramActivity : UIActivity <UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) NSString *shareString;
@property (nonatomic, strong) NSArray *backgroundColors;
@property (nonatomic, assign) BOOL includeURL;

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@property (nonatomic, strong) UIBarButtonItem * barButtonItem;


@end
