//
//  CCEditMediaViewController.h
//  ChitChat
//
//  Created by Jinjin Lee on 10/20/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCBaseViewController.h"
#import "FeSlideFilterView.h"
#import "CIFilter+LUT.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CustomIOSAlertView/CustomIOSAlertView.h>
#import "CCTrendingTagAlertView.h"

typedef NS_ENUM(NSUInteger, EditMediaStatus) {
    
    EditMediaStatusText = 0,
    EditMediaStatusDraw,
};

@interface CCEditMediaViewController : CCBaseViewController <ACEDrawingViewDelegate, HPGrowingTextViewDelegate, FeSlideFilterViewDelegate, FeSlideFilterViewDataSource, CTVideoViewOperationDelegate, CCTrendingTagAlertViewDelegate> {
    
    FeSlideFilterView       *m_feSliderFilterView;
    
    NSMutableArray          *m_aryPhotos;
    NSMutableArray          *m_aryTitles;
    NSMutableArray          *m_aryEmojis;
    
    NSArray                 *m_aryTrendingTag;
    
    BOOL                    m_bShowText;
    BOOL                    m_bNormalText;
    BOOL                    m_bTouchedText;
    BOOL                    m_bDraw;
    BOOL                    m_bMultiTouch;
    
    CGPoint                 m_ptTouched;
    
    EditMediaStatus         m_nEditMediaStatus;
}

@property (weak, nonatomic) IBOutlet UIView *m_vwMedia;
@property (weak, nonatomic) IBOutlet ACEDrawingView *m_vwDraw;
@property (weak, nonatomic) IBOutlet UIView *m_vwFilter;
@property (weak, nonatomic) IBOutlet UIView *m_vwText;
@property (weak, nonatomic) IBOutlet HPGrowingTextView *m_txtComment;
@property (weak, nonatomic) IBOutlet UIView *m_vwTouchText;

@property (retain, nonatomic) SimpleColorPickerView *m_vwColorPicker;
@property (weak, nonatomic) IBOutlet UIButton *m_btnPencil;
@property (weak, nonatomic) IBOutlet UIButton *m_btnUndo;
@property (weak, nonatomic) IBOutlet UIButton *m_btnFont;
@property (weak, nonatomic) IBOutlet UIButton *m_btnEmoji;
@property (weak, nonatomic) IBOutlet UIButton *m_btnClose;
@property (weak, nonatomic) IBOutlet UIButton *m_btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *m_btnSave;
@property (weak, nonatomic) IBOutlet UIView *m_vwEmoji;
@property (weak, nonatomic) IBOutlet UICollectionView *m_colEmoji;
@property (weak, nonatomic) IBOutlet CTVideoView   *m_vwVideo;

@property (retain, nonatomic) StoryObj      *m_storyObj;
@property (retain, nonatomic) UIImage       *m_imgBackground;


@property (weak, nonatomic) IBOutlet UIView *m_vwAlertParent;

- (IBAction)onClickPencil:(id)sender;
- (IBAction)onClickUndo:(id)sender;
- (IBAction)onClickFont:(id)sender;
- (IBAction)onClickEmoji:(id)sender;
- (IBAction)onClickClose:(id)sender;
- (IBAction)onClickSubmit:(id)sender;
- (IBAction)onClickSave:(id)sender;


@end
