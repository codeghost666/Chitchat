//
//  CCEditMediaViewController.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/20/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCEditMediaViewController.h"
#import "CCEmojiCollectionViewCell.h"

#define TEXT_NORMAL_SIZE                25
#define TEXT_LARGE_SIZE                 40
#define TEXT_NORMAL_FONT                @"Avenir-Medium"
#define TEXT_LARGE_FONT                 @"Avenir-Heavy"
#define TEXT_NORMAL_BGCOLOR             [UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.2f]
#define TEXT_LARGE_BGCOLOR              [UIColor clearColor]

#define DRAW_LINE_WIDTH                 5
#define DRAW_LINE_COLOR                 [UIColor whiteColor]

#define PEN_IMAGE                       [UIImage imageNamed:@"ic_pencil"]
#define UNDO_IMAGE                      [UIImage imageNamed:@"ic_undo"]

#define EMOJI_SIZE                      120
#define EMOJI_TAG                       1000

#define COLOR_PICKER_WIDTH              30
#define COLOR_PICKER_HEIGHT             150

@interface CCEditMediaViewController ()

@end

@implementation CCEditMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViewController];
}

- (void) viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [self.view layoutIfNeeded];
    
    if (!self.m_vwColorPicker) {
        
        [self initColorPickerview];
    }
    
    if (!m_feSliderFilterView) {
        
        [self initFilterSliderView];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.m_vwVideo play];
}

- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.m_vwVideo stopWithReleaseVideo:YES];
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

- (IBAction)onClickPencil:(id)sender {
    
    m_nEditMediaStatus == EditMediaStatusText ? [self setDrawStatus] : [self setTextStatus];
}

- (IBAction)onClickUndo:(id)sender {
    
    [self.m_vwDraw undoLatestStep];
    [self.m_btnUndo setHidden:![self.m_vwDraw canUndo]];
}

- (IBAction)onClickFont:(id)sender {
    
    [self changeTextSize];
}

- (IBAction)onClickEmoji:(id)sender {
    
    if (self.m_vwEmoji.hidden) {
        
        [self showEmojiMenu];
    }
    else {
        
        [self hideEmojiMenu];
    }
}

- (IBAction)onClickClose:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RESET_CAMERA object:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)onClickSubmit:(id)sender {
    
    [self showTrendingAlertView];
}

- (IBAction)onClickSave:(id)sender {
    
    [self saveMedia];
}

# pragma mark - Initialize Handler

- (void) initViewController {
    
    // init media view
    StoryType nStoryType = self.m_storyObj.story_type.integerValue;
    if (nStoryType == StoryTypePhoto) {
        
        [self initPhotoView];
    }
    else if (nStoryType == StoryTypeVideo) {
        
        [self initVideoView];
    }
    
    // init trending tag variable
    m_aryTrendingTag = @[
                         @[
                             @{TRENDING_TAG_FEATURED  : @3},
                             @{TRENDING_TAG_SELFIES   : @34393},
                             @{TRENDING_TAG_SEXY      : @34400},
                             @{TRENDING_TAG_HOTRORNAH : @33391},
                             @{TRENDING_TAG_LETSCHAT  : @42853},
                             @{TRENDING_TAG_ADDME     : @34405},
                             @{TRENDING_TAG_420       : @500001}
                             ],
                         @[
                             @{TRENDING_TAG_FEATURED  : @4},
                             @{TRENDING_TAG_SELFIES   : @34451},
                             @{TRENDING_TAG_SEXY      : @34459},
                             @{TRENDING_TAG_HOTRORNAH : @34407},
                             @{TRENDING_TAG_LETSCHAT  : @34463},
                             @{TRENDING_TAG_ADDME     : @34461},
                             @{TRENDING_TAG_420       : @500002}
                             ],
                         ];
    
    // init views
    [self initEmojiView];
    [self initText];
    [self initDraw];
    [self addGestures];
    
    self.m_btnUndo.hidden = YES;
    self.m_btnFont.hidden = YES;
    
    self.m_vwAlertParent.hidden = YES;
}

- (void) initPhotoView {
    
    [self initFilters];
    [self initFilterTitle];
}

- (void) initFilters {
    
    m_aryPhotos = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 5; i ++) {
        if (i == 0                  // origin photo
            || i == 4)              // time photo
        {
            [m_aryPhotos addObject:self.m_imgBackground];
        }
        else {
            
            NSString *strFilter = [[NSString alloc] init];
            
            if (i == 1)                 // tan filter
            {
                strFilter = @"edit_filter_tan";
            }
            else if (i == 2)                 // white filter
            {
                strFilter = @"edit_filter_white";
            }
            else if (i == 3)                 // black filter
            {
                strFilter = @"edit_filter_black";
            }
            
            // Create filter
            CIFilter *lutFilter = [CIFilter filterWithLUT:strFilter dimension:64];
            
            // Set parameter
            CIImage *ciImage = [[CIImage alloc] initWithImage:self.m_imgBackground];
            [lutFilter setValue:ciImage forKey:@"inputImage"];
            CIImage *outputImage = [lutFilter outputImage];
            
            CIContext *context = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:(__bridge id)(CGColorSpaceCreateDeviceRGB()) forKey:kCIContextWorkingColorSpace]];
            
            UIImage *newImage = [UIImage imageWithCGImage:[context createCGImage:outputImage fromRect:outputImage.extent]];
            
            [m_aryPhotos addObject:newImage];
        }
    }
}

- (void) initFilterTitle {
    
    m_aryTitles = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 5; i ++)
    {
/*        if (i == 4) {            // F Temp
            
            [m_aryTitles addObject:[NSString stringWithFormat:@"%@ F", [[GlobalData sharedInstance].g_curTemperature stringValue]]];
        }*/
        if (i == 4) {       // Time
            
            NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
            [dateFomatter setDateFormat:@"h:mm a"];
            
            [m_aryTitles addObject:[dateFomatter stringFromDate:[NSDate date]]];
        }
        else {
            
            [m_aryTitles addObject:@""];
        }
    }
}

- (void) initFilterSliderView {
    
    m_feSliderFilterView = [[FeSlideFilterView alloc] initWithFrame:self.view.frame];
    m_feSliderFilterView.dataSource = self;
    m_feSliderFilterView.delegate = self;
    
    [self.m_vwFilter addSubview:m_feSliderFilterView];
}

- (void) initVideoView {
    
    // set video view
    self.m_vwVideo.hidden = NO;
    self.m_vwVideo.operationDelegate = self;
    self.m_vwVideo.userInteractionEnabled = NO;
    self.m_vwVideo.videoUrl = [NSURL URLWithString:self.m_storyObj.story_main_url];
    self.m_vwVideo.shouldReplayWhenFinish = YES;
    [self.m_vwVideo prepare];
    
    // arrange media views
    [self.m_vwMedia bringSubviewToFront:self.m_vwFilter];
    [self.m_vwDraw setUserInteractionEnabled:NO];
    [self.m_vwMedia bringSubviewToFront:self.m_vwDraw];
    [self.m_vwMedia bringSubviewToFront:self.m_vwText];
}

- (void) initEmojiView {
    
    self.m_vwEmoji.hidden = YES;
    m_aryEmojis = [NSMutableArray new];
}

- (void) initText {
    
    [self.m_txtComment setBackgroundColor:TEXT_NORMAL_BGCOLOR];
    [self.m_txtComment setTextAlignment:NSTextAlignmentCenter];
    [self.m_txtComment setMaxNumberOfLines:100];
    [self.m_txtComment setFont:[UIFont fontWithName:TEXT_NORMAL_FONT size:TEXT_NORMAL_SIZE]];
    [self.m_txtComment setTextColor:[UIColor whiteColor]];
    [self.m_txtComment setReturnKeyType:UIReturnKeyDone];
    self.m_txtComment.delegate = self;
    
    [self.m_vwText setHidden:YES];
    [self.m_vwText.layer setAnchorPoint:CGPointMake(.5f, .5f)];
    
    m_bNormalText = YES;
}

- (void) initDraw {
    
    self.m_vwDraw.delegate = self;
    self.m_vwDraw.lineWidth = DRAW_LINE_WIDTH;
    self.m_vwDraw.lineColor = DRAW_LINE_COLOR;
}

- (void) addGestures {
    
    // add tap gesture for show hidden text when first tap screen
    [self.m_vwFilter setUserInteractionEnabled:YES];
    [self.m_vwFilter addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showText:)]];
    
    // add tap gesture for editting text
    [self.m_vwTouchText setUserInteractionEnabled:YES];
    [self.m_vwTouchText addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyboard)]];
    [self.m_vwTouchText addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchText:)]];
    [self.m_vwTouchText addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateText:)]];
    [self.m_vwTouchText addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panText:)]];
}

- (void) initColorPickerview {
    
    CGRect frame = self.m_btnPencil.frame;
    frame.origin.x = frame.origin.x + (frame.size.width - COLOR_PICKER_WIDTH) / 2;
    frame.origin.y = frame.origin.y + frame.size.height + 10;
    frame.size.width = COLOR_PICKER_WIDTH;
    frame.size.height = COLOR_PICKER_HEIGHT;
    
    self.m_vwColorPicker = [[SimpleColorPickerView alloc] initWithFrame:frame withDidPickColorBlock:^(UIColor *color) {
        
        // Change color Handler
        [self changePenColor:color];
    }];
    
    [self.view addSubview:self.m_vwColorPicker];
    
    self.m_vwColorPicker.hidden = YES;
}

# pragma mark - Emoji Handler
# pragma mark - Emoji View Handler
- (void) showEmojiMenu {
    
    self.m_vwEmoji.hidden = NO;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.m_vwEmoji.alpha = 1.0f;
                         
                     } completion:nil];
    
    [self.m_btnFont setHidden:YES];
    [self.m_btnPencil setHidden:YES];
}

- (void) hideEmojiMenu {
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.m_vwEmoji.alpha = 0.0f;
                         
                     } completion:^(BOOL finished) {
                         
                         if (finished) {
                             
                             self.m_vwEmoji.hidden = YES;
                         }
                     }];
    
    [self.m_btnPencil setHidden:NO];
    [self.m_btnFont setHidden:self.m_txtComment.text.length == 0];
}

- (void) addEmoji:(UIImage *)image {
    
    [self hideEmojiMenu];
    
    UIImageView *imgEmoji = [[UIImageView alloc] initWithImage:image];
    
    [imgEmoji setFrame:CGRectMake(100, 100, EMOJI_SIZE, EMOJI_SIZE)];
    [imgEmoji setTag:[m_aryEmojis count] + EMOJI_TAG];
    
    [imgEmoji setUserInteractionEnabled:YES];
    
    [imgEmoji addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEmoji:)]];
    [imgEmoji addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchEmoji:)]];
    [imgEmoji addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateEmoji:)]];
    
    [self.m_vwMedia addSubview:imgEmoji];
    [self.m_vwMedia bringSubviewToFront:imgEmoji];
    
    [m_aryEmojis addObject:imgEmoji];
}

- (void) panEmoji:(UIPanGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:self.view];
    
    UIImageView *imgEmoji = (UIImageView *)gesture.view;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        m_ptTouched = point;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged
             || gesture.state == UIGestureRecognizerStateEnded)
    {
        CGAffineTransform transform = imgEmoji.transform;
        [imgEmoji setTransform:CGAffineTransformMakeRotation(0.f)];
        
        [imgEmoji setFrame:CGRectMake(imgEmoji.frame.origin.x + (point.x - m_ptTouched.x),
                                      imgEmoji.frame.origin.y + (point.y - m_ptTouched.y),
                                      imgEmoji.frame.size.width,
                                      imgEmoji.frame.size.height)];
        
        [imgEmoji setTransform:transform];
        
        m_ptTouched = point;
    }
}

- (void) pinchEmoji:(UIPinchGestureRecognizer *)gesture {
    
    UIImageView *imgEmoji = (UIImageView *)gesture.view;
    
    [imgEmoji setTransform:CGAffineTransformRotate(imgEmoji.transform, 0)];
    [imgEmoji setTransform:CGAffineTransformScale(imgEmoji.transform, gesture.scale, gesture.scale)];
    
    gesture.scale = 1.0;
}

- (void) rotateEmoji:(UIRotationGestureRecognizer *)gesture {
    UIImageView *imgEmoji = (UIImageView *)gesture.view;
    
    [imgEmoji setTransform:CGAffineTransformRotate(imgEmoji.transform, gesture.rotation)];
    
    gesture.rotation = 0.f;
}

# pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(CGRectGetHeight(self.m_colEmoji.frame) - 40, CGRectGetHeight(self.m_colEmoji.frame) - 30);
}

#pragma mark - UICollectionView DataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CCEmojiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCEmojiCollectionViewCell" forIndexPath:indexPath];
    cell.emojiObj = [GlobalData sharedInstance].g_aryEmojis[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [GlobalData sharedInstance].g_aryEmojis.count;
}

# pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CCEmojiCollectionViewCell *cell = (CCEmojiCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self addEmoji:cell.m_ivEmoji.image];
}


# pragma mark - Filter Handler
# pragma mark - FeSliderFilterView delegate

-(NSInteger) numberOfFilter {
    
    return [m_aryPhotos count];
}

-(NSString *) FeSlideFilterView:(FeSlideFilterView *)sender titleFilterAtIndex:(NSInteger)index {
    
    return m_aryTitles[index];
}

-(UIImage *) FeSlideFilterView:(FeSlideFilterView *)sender imageFilterAtIndex:(NSInteger)index {
    
    return m_aryPhotos[index];
}

#pragma mark - ACEDrawingView delegate

- (void) drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool {
    
    [self.m_btnUndo setHidden:![self.m_vwDraw canUndo]];
}


#pragma mark - HPGrowingText delegate

- (BOOL) growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self hideKeyboard];
        
        return NO;
    }
    
    return YES;
}

- (void) growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    [self.m_btnFont setHidden:(self.m_txtComment.text.length == 0)];
    [self updateTextViewFrame];
}

# pragma mark - Draw Handler
# pragma mark - Change Color Handler
- (void) changePenColor:(UIColor *)color {
    
    [self.m_vwDraw setLineColor:color];
    
    [self.m_btnPencil setImage:[self coloredImage:PEN_IMAGE withColor:color] forState:UIControlStateNormal];
    [self.m_btnUndo setImage:[self coloredImage:UNDO_IMAGE withColor:color] forState:UIControlStateNormal];
}

-(UIImage *)coloredImage:(UIImage *)firstImage withColor:(UIColor *)color {
    
    UIGraphicsBeginImageContext(firstImage.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    
    CGContextTranslateCTM(context, 0, firstImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGRect rect = CGRectMake(0, 0, firstImage.size.width, firstImage.size.height);
    CGContextDrawImage(context, rect, firstImage.CGImage);
    
    CGContextClipToMask(context, rect, firstImage.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImg;
}

# pragma mark - Text Handler
# pragma mark - Keyboard Handler
- (void) showKeyboard {
    [self.m_txtComment becomeFirstResponder];
    
    [self.m_vwText bringSubviewToFront:_m_txtComment];
    
    [self initTransform];
}

- (void) hideKeyboard
{
    [self.m_txtComment resignFirstResponder];
    
    [self.m_vwText bringSubviewToFront:self.m_vwTouchText];
    
    if (_m_txtComment.text.length == 0) {
        
        m_bShowText = NO;
        [self.m_vwText setHidden:YES];
    }
}

# pragma mark - Text Transform Handler
- (void) initTransform {
    
    [self.m_vwText setTransform:CGAffineTransformRotate(self.m_vwText.transform, 0)];
    [self.m_vwText setTransform:CGAffineTransformMakeScale(1.f, 1.f)];
}

- (void) checkTouchedText:(CGPoint) point {
    
    if (CGRectContainsPoint(self.m_vwText.frame, point)) {
        
        m_bTouchedText = YES;
        m_ptTouched = point;
    }
}

- (void) moveTouchedText:(CGPoint) point {
    
    CGAffineTransform transform = self.m_vwText.transform;
    [self.m_vwText setTransform:CGAffineTransformMakeRotation(0.f)];
    
    [self.m_vwText setFrame:CGRectMake(m_bNormalText ? 0 : self.m_vwText.frame.origin.x + (point.x - m_ptTouched.x),
                                       self.m_vwText.frame.origin.y + (point.y - m_ptTouched.y),
                                       self.m_vwText.frame.size.width,
                                       self.m_vwText.frame.size.height)];
    
    [self.m_vwText setTransform:transform];
    
    m_ptTouched = point;
}

- (void) updateTextViewFrame {
    
    // disable text view autolayout
    self.m_vwText.translatesAutoresizingMaskIntoConstraints = YES;
    
    int height = self.m_txtComment.frame.size.height;
    
    CGAffineTransform transform = self.m_vwText.transform;
    [self.m_vwText setTransform:CGAffineTransformMakeRotation(0.f)];
    
    [self.m_vwText setFrame:CGRectMake(m_bNormalText ? 0 : self.m_vwText.frame.origin.x, self.m_vwText.frame.origin.y, self.m_vwText.frame.size.width, height)];
    [self.m_vwTouchText setFrame:CGRectMake(m_bNormalText ? 0 :self.m_vwTouchText.frame.origin.x, self.m_vwText.frame.origin.y, self.m_vwText.frame.size.width, height)];
    
    [self.m_vwText setTransform:transform];
}

- (void) changeTextSize {
    
    m_bNormalText = !m_bNormalText;
    
    [self.m_txtComment setFont:[UIFont fontWithName:m_bNormalText ? TEXT_NORMAL_FONT : TEXT_LARGE_FONT size:m_bNormalText ? TEXT_NORMAL_SIZE : TEXT_LARGE_SIZE]];
    [self.m_txtComment setBackgroundColor:m_bNormalText ? TEXT_NORMAL_BGCOLOR : TEXT_LARGE_BGCOLOR];
    if (m_bNormalText)
        [self initTransform];
    
    [self.m_txtComment refreshHeight];
}

- (void) showText:(UITapGestureRecognizer *)gesture {
    
    if (!m_bShowText) {
        
        m_bShowText = YES;
        m_nEditMediaStatus = EditMediaStatusText;
        
        [self.m_vwText setHidden:NO];
        
        [self showKeyboard];
    }
    else
    {
        [self hideKeyboard];
        [self hideEmojiMenu];
    }
}

- (void) pinchText:(UIPinchGestureRecognizer *)gesture {
    
    if (m_nEditMediaStatus == EditMediaStatusText && !m_bNormalText) {
        
        [self.m_vwText setTransform:CGAffineTransformRotate(self.m_vwText.transform, 0)];
        [self.m_vwText setTransform:CGAffineTransformScale(self.m_vwText.transform, gesture.scale, gesture.scale)];
        
        gesture.scale = 1.0;
        
        m_bMultiTouch = !(gesture.state == UIGestureRecognizerStateEnded);
    }
}

- (void) rotateText:(UIRotationGestureRecognizer *)gesture {
    
    if (m_nEditMediaStatus == EditMediaStatusText && !m_bNormalText) {
        
        [self.m_vwText setTransform:CGAffineTransformRotate(self.m_vwText.transform, gesture.rotation)];
        
        gesture.rotation = 0.f;
        
        m_bMultiTouch = !(gesture.state == UIGestureRecognizerStateEnded);
    }
}

- (void) panText:(UIPanGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:self.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        m_ptTouched = point;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged
             || gesture.state ==  UIGestureRecognizerStateEnded) {
        
        CGAffineTransform transform = self.m_vwText.transform;
        [self.m_vwText setTransform:CGAffineTransformMakeRotation(0.f)];
        
        [self.m_vwText setFrame:CGRectMake(m_bNormalText ? 0 : self.m_vwText.frame.origin.x + (point.x - m_ptTouched.x),
                                           self.m_vwText.frame.origin.y + (point.y - m_ptTouched.y),
                                           self.m_vwText.frame.size.width,
                                           self.m_vwText.frame.size.height)];
        
        [self.m_vwText setTransform:transform];
        
        m_ptTouched = point;
    }
}

# pragma mark - Edit Status Handler
- (void) setDrawStatus {
    
    m_nEditMediaStatus = EditMediaStatusDraw;
    
    [self.m_btnEmoji setHidden:YES];
    [self.m_btnFont setHidden:YES];
    [self.m_vwColorPicker setHidden:NO];
    
    [_m_btnUndo setHidden:![self.m_vwDraw canUndo]];
    
    [self.m_vwMedia bringSubviewToFront:self.m_vwDraw];
    [self.m_vwDraw setUserInteractionEnabled:YES];
}

- (void) setTextStatus {
    
    m_nEditMediaStatus = EditMediaStatusText;
    
    [self.m_btnEmoji setHidden:NO];
    [self.m_btnFont setHidden:NO];
    [self.m_btnUndo setHidden:YES];
    [self.m_vwColorPicker setHidden:YES];
    
    [self.m_btnFont setHidden:(self.m_txtComment.text.length == 0)];
    
    [self.m_vwMedia bringSubviewToFront:self.m_vwFilter];
    [self.m_vwDraw setUserInteractionEnabled:NO];
    [self.m_vwMedia bringSubviewToFront:self.m_vwDraw];
    [self.m_vwMedia bringSubviewToFront:self.m_vwText];
    
    for (int i = 0; i < [m_aryEmojis count]; i ++) {
        
        [self.m_vwMedia bringSubviewToFront:(UIImageView *)[m_aryEmojis objectAtIndex:i]];
    }
}

# pragma mark - Save and Submit Handler
- (void) saveMedia {
    
    if (self.m_storyObj.story_type.integerValue == StoryTypePhoto)
    {
        UIImageWriteToSavedPhotosAlbum([self getPhoto:self.m_vwMedia], nil, nil, NULL);
        [SVProgressHUD showSuccessWithStatus:@"Photo saved to camera roll successfully!"];
    }
    else {
        
        NSURL *videoURL = [NSURL URLWithString:self.m_storyObj.story_main_url];
        
        [videoURL saveToCameraRollWithCompletion:^(NSString * _Nullable path, NSError * _Nullable error) {
            
            if (error == nil) {
                
                [SVProgressHUD showSuccessWithStatus:@"Video saved to camera roll successfully!"];
            }
            else {
                
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Cannot save video to library!\n%@", error.localizedDescription]];
            }
            
        }];
    }
}

- (UIImage *) getPhoto:(UIView *)view {
    
    UIImage *image = [[UIImage alloc] init];
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0f);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    return image;
}

- (UIImage *) getThumbnailImageFromVideoURL:(NSString *) strURL {
    
    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:strURL]];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    CMTime time = CMTimeMake(1, 1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}

# pragma mark - Trending Alert View Handler

- (void) showTrendingAlertView {
    
    // create alert view
    CCTrendingTagAlertView *alertView = [[NSBundle mainBundle] loadNibNamed:@"CCTrendingTagAlertView" owner:nil options:nil][0];
    alertView.trendingTags = [GlobalData sharedInstance].g_selfUser.user_gender.integerValue == UserGenderMale ? m_aryTrendingTag[0] : m_aryTrendingTag[1];
    alertView.delegate = self;
    alertView.parentVC = self;
    alertView.tag = 1;

    alertView.center = self.m_vwAlertParent.center;
    [self.m_vwAlertParent addSubview:alertView];
    
    self.m_vwAlertParent.hidden = NO;
}

# pragma mark - Trending Tag Alert View Delegate

- (void) didClickSubmit:(NSDictionary *)trending_tag {
    
    [self submitStoryWithTrendingTagId:trending_tag[trending_tag.allKeys[0]]];
    
    self.m_vwAlertParent.hidden = YES;
    [[self.m_vwAlertParent viewWithTag:1] removeFromSuperview];
}

- (void) didClickClose {
    
    self.m_vwAlertParent.hidden = YES;
    [[self.m_vwAlertParent viewWithTag:1] removeFromSuperview];
    
    // submit story
    [self submitStoryWithTrendingTagId:@0];
}

- (void) submitStoryWithTrendingTagId:(NSNumber *) trending_tag_id {
    
    NSData *mainMedia = nil;
    NSData *editMedia = nil;
    NSData *thumbMedia = nil;
    
    if (self.m_storyObj.story_type.intValue == StoryTypePhoto) {
        
        mainMedia = UIImageJPEGRepresentation([self getPhoto:self.m_vwMedia], 0.1f);
    }
    else {
    
        self.m_vwVideo.shouldReplayWhenFinish = NO;
        [self.m_vwVideo stopWithReleaseVideo:YES];
        
        mainMedia = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.m_storyObj.story_main_url]];
        editMedia = UIImagePNGRepresentation([self getPhoto:self.m_vwMedia]);
        thumbMedia = UIImageJPEGRepresentation([self getThumbnailImageFromVideoURL:self.m_storyObj.story_main_url], 0.1f);
    }
    
    // upload media
    self.m_btnSubmit.userInteractionEnabled = NO;
    self.m_storyObj.story_is_vip = (trending_tag_id.integerValue == 3 || trending_tag_id.integerValue == 4) ? @YES : @NO;
    
    SHOW_WAIT_MESSAGE;
    [[WebService sharedInstance] addStoryWithStoryObj:self.m_storyObj
                                        TrendingTagId:trending_tag_id
                                            MainMedia:mainMedia
                                            EditMedia:editMedia
                                           ThumbMedia:thumbMedia
                                             Progress:^(float progress) {
                                                 
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                    
                                                     [SVProgressHUD showProgress:progress status:@"Uploading ..."];
                                                 });
                                                 
                                             } Success:^(id response) {
                                                 
                                                 DISMISS_MESSAGE;
                                                 
                                                 // set my coins
                                                 if (self.m_storyObj.story_is_vip.boolValue) {
                                                     
                                                     [self decUserCoinCount:VIP_COIN_COUNT];
                                                 }
                                                 
                                                 // check first submit
                                                 if (![[NSUserDefaults standardUserDefaults] boolForKey:CONFIG_KEY_ALREADY_SUBMITTED]) {
                                                    
                                                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                                                                    message:@"Your story will be approved ASAP"
                                                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                                     UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                        style:UIAlertActionStyleCancel
                                                                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                                                                         
                                                                                                          // set already submitted flag
                                                                                                          [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CONFIG_KEY_ALREADY_SUBMITTED];
                                                                                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                                          
                                                                                                          // goto screen
                                                                                                          [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                                          
                                                                                                      }];
                                                     [alert addAction:okAction];
                                                     [self presentViewController:alert animated:YES completion:nil];
                                                 }
                                                 else {
                                                     
                                                     // goto screen
                                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                                 }
                                                 
                                             } Failure:^(NSString *error) {
                                                
                                                 SHOW_ERROR_MESSAGE(error);
                                                 self.m_btnSubmit.userInteractionEnabled = YES;
                                             }];
}

- (void) decUserCoinCount:(NSInteger) coin_count {
    
    [[WebService sharedInstance] updateCoinWithUserId:[GlobalData sharedInstance].g_selfUser.user_id
                                            CoinCount:@(coin_count)
                                           UpdateType:@(UpdateCoinCountTypeDec)
                                              Success:^(id response) {
                                                  
                                                  // set my coin count
                                                  NSInteger coins = [GlobalData sharedInstance].g_selfUser.user_coin_count.integerValue - coin_count;
                                                  [GlobalData sharedInstance].g_selfUser.user_coin_count = @(coins);
                                                  [[GlobalData sharedInstance] saveConfigData];
                                                  
                                              } Failure:^(NSString *error) {
                                                 
                                                  SHOW_ERROR_MESSAGE(error);
                                              }];
}

@end
