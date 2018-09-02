//
//  CCChatViewController.m
//  ChitChat
//
//  Created by Jinjin Lee on 11/1/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCChatViewController.h"
#import "CCChatTextCell.h"
#import "CCChatAttachmentCell.h"
#import "CCChatHeaderCollectionReusableView.h"
#import "QMChatSection.h"

#import <SafariServices/SFSafariViewController.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <TOCropViewController/TOCropViewController.h>

#define CHAT_HISTORY_LIMIT      7


static const NSUInteger widthPadding = 40.0f;
static const NSUInteger maxCharactersNumber = 1024; // 0 - unlimited


@interface CCChatViewController () <QMChatServiceDelegate, UITextViewDelegate, QMChatConnectionDelegate, QMChatAttachmentServiceDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, QMChatCellDelegate, TOCropViewControllerDelegate>

@property (nonatomic, weak) QBUUser *opponentUser;
@property (nonatomic, strong) NSMapTable *attachmentCells;
@property (nonatomic, readonly) UIImagePickerController *pickerController;
@property (nonatomic, strong) NSTimer *typingTimer;
@property (nonatomic, strong) id observerWillResignActive;

@property (nonatomic, strong) NSArray QB_GENERIC(QBChatMessage *) *unreadMessages;

@property (nonatomic, strong) NSMutableSet *detailedCells;

@end

@implementation CCChatViewController

@synthesize pickerController = _pickerController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViewController];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    __weak __typeof(self)weakSelf = self;
    self.observerWillResignActive = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification
                                                                                      object:nil
                                                                                       queue:nil
                                                                                  usingBlock:^(NSNotification *note) {
                                                                                      [weakSelf fireStopTypingIfNecessary];
                                                                                  }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self.observerWillResignActive];
    
    // Deletes typing blocks.
    [self.dialog clearTypingStatusBlocks];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImagePickerController *)pickerController {
    if (_pickerController == nil) {
        _pickerController = [UIImagePickerController new];
        _pickerController.delegate = self;
    }
    return _pickerController;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Override

- (NSUInteger)senderID {
    return [QBSession currentSession].currentUser.ID;
}

- (NSString *)senderDisplayName {
    return [QBSession currentSession].currentUser.login;
}

- (CGFloat)heightForSectionHeader {
    
    return 30.0f;
}


# pragma mark - Initialize Handler

- (void) initViewController {
    
    /**
     *  Register text cell
     */
    UINib *chatTextCellNib = [UINib nibWithNibName:@"CCChatTextCell" bundle: nil];
    NSString *chatTextCellIdentifier = [CCChatTextCell cellReuseIdentifier];
    [self.collectionView  registerNib:chatTextCellNib forCellWithReuseIdentifier:chatTextCellIdentifier];
    /**
     *  Register attachment cell
     */
    UINib *attachmentCellNib  = [UINib nibWithNibName:@"CCChatAttachmentCell" bundle: nil];
    NSString *attachmentCellIdentifier = [CCChatAttachmentCell cellReuseIdentifier];
    [self.collectionView registerNib:attachmentCellNib forCellWithReuseIdentifier:attachmentCellIdentifier];
    /**
     *  Register section header view
     */
    UINib *sectionHeaderNib  = [CCChatHeaderCollectionReusableView nib];
    NSString *sectionHeaderIdentifier = [CCChatHeaderCollectionReusableView cellReuseIdentifier];
    [self.collectionView registerNib:sectionHeaderNib
          forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                 withReuseIdentifier:sectionHeaderIdentifier];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.inputToolbar.contentView.backgroundColor = [UIColor whiteColor];
    self.inputToolbar.contentView.textView.placeHolder = @"Message";
    UIButton *leftButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButtonItem.frame = CGRectMake(0, 0, 38.f, 40.f);
    [leftButtonItem setImage:[UIImage imageNamed:@"ic_accessory"] forState:UIControlStateNormal];
    self.inputToolbar.contentView.leftBarButtonItem = leftButtonItem;
    
    self.attachmentCells = [NSMapTable strongToWeakObjectsMapTable];
    self.detailedCells = [NSMutableSet set];
    
    self.enableTextCheckingTypes = NSTextCheckingAllTypes;
    
    [self updateTitle];
    
    if (self.dialog.type == QBChatDialogTypePrivate) {
        
        // Handling 'typing' status.
        __weak typeof(self)weakSelf = self;
        [self.dialog setOnUserIsTyping:^(NSUInteger userID) {
            
            if ([QBSession currentSession].currentUser.ID == userID) {
                return;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CHANGE_TITLE
                                                                object:nil
                                                              userInfo:@{@"title" : @"Typing..."}];
        }];
        
        // Handling user stopped typing.
        [self.dialog setOnUserStoppedTyping:^(NSUInteger userID) {
            
            __typeof(weakSelf)strongSelf = weakSelf;
            if ([QBSession currentSession].currentUser.ID == userID) {
                return;
            }
            [strongSelf updateTitle];
        }];
    }
    
    [[QMServicesManager instance].chatService addDelegate:self];
    [QMServicesManager instance].chatService.chatAttachmentService.delegate = self;
    
    if ([[self storedMessages] count] > 0 && self.chatSectionManager.totalMessagesCount == 0) {
        
        // inserting all messages from memory storage
        [self.chatSectionManager addMessages:[self storedMessages]];
    }
    
    [self refreshMessagesShowingProgress:NO];
}

- (void) updateTitle {
    
    NSMutableArray *mutableOccupants = [self.dialog.occupantIDs mutableCopy];
    [mutableOccupants removeObject:@([self senderID])];
    NSNumber *opponentID = [mutableOccupants firstObject];
    QBUUser *opponentUser = [[QMServicesManager instance].usersService.usersMemoryStorage userWithID:[opponentID unsignedIntegerValue]];
    if (!opponentUser) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CHANGE_TITLE
                                                            object:nil
                                                          userInfo:@{@"title" : self.dialog.name}];
        return;
    }
    self.opponentUser = opponentUser;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CHANGE_TITLE
                                                        object:nil
                                                      userInfo:@{@"title" : self.dialog.name}];
}

- (NSArray *)storedMessages {
    
    return [[QMServicesManager instance].chatService.messagesMemoryStorage messagesWithDialogID:self.dialog.ID];
}

- (void)refreshMessagesShowingProgress:(BOOL)showingProgress {
    
    if (showingProgress) {
        SHOW_WAIT_MESSAGE;
    }
    
    __weak __typeof(self)weakSelf = self;
    
    // Retrieving messages from Quickblox REST history and cache.
    [[QMServicesManager instance].chatService messagesWithChatDialogID:self.dialog.ID completion:^(QBResponse *response, NSArray *messages) {
        if (response.success) {
            
            if ([messages count] > 0) {
                [weakSelf.chatSectionManager addMessages:messages];
            }
            
            DISMISS_MESSAGE;
            
        } else {
            
            SHOW_ERROR_MESSAGE(response.error.description);
        }
    }];
}

#pragma mark - Utilities

- (void)sendReadStatusForMessage:(QBChatMessage *)message {
    
    if (message.senderID != self.senderID && ![message.readIDs containsObject:@(self.senderID)]) {
        [[QMServicesManager instance].chatService readMessage:message completion:^(NSError *error) {
            if (error != nil) {
                NSLog(@"Problems while marking message as read! Error: %@", error);
                return;
            }
        }];
    }
}

- (void)readMessages:(NSArray *)messages {
    
    if ([QMServicesManager instance].isAuthorized) {
        
        [[QMServicesManager instance].chatService readMessages:messages forDialogID:self.dialog.ID completion:nil];
    }
    else {
        
        self.unreadMessages = messages;
    }
}

- (void)fireStopTypingIfNecessary {
    
    [self.typingTimer invalidate];
    self.typingTimer = nil;
    [self.dialog sendUserStoppedTyping];
}

#pragma mark Tool bar Actions

- (void)didPressSendButton:(UIButton *)button
       withTextAttachments:(NSArray*)textAttachments
                  senderId:(NSUInteger)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date {
    
    NSTextAttachment * attachment = textAttachments.firstObject;
    
    if (attachment.image) {
        
        QBChatMessage *message = [QBChatMessage new];
        message.senderID = self.senderID;
        message.dialogID = self.dialog.ID;
        message.dateSent = [NSDate date];
        
        [[QMServicesManager instance].chatService sendAttachmentMessage:message
                                                               toDialog:self.dialog
                                                    withAttachmentImage:attachment.image
                                                             completion:^(NSError *error) {
                                                                 
                                                                 [self.attachmentCells removeObjectForKey:message.ID];
                                                                 
                                                                 if (error != nil) {
                                                                     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                                     
                                                                     // perform local attachment deleting
                                                                     [[QMServicesManager instance].chatService deleteMessageLocally:message];
                                                                     [self.chatSectionManager deleteMessage:message];
                                                                 }
                                                             }];
        [self finishSendingMessageAnimated:YES];
    }
}


- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSUInteger)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date {
    
    if (self.typingTimer != nil) {
        [self fireStopTypingIfNecessary];
    }
    
    QBChatMessage *message = [QBChatMessage message];
    message.text = text;
    message.senderID = senderId;
    message.markable = YES;
    message.deliveredIDs = @[@(self.senderID)];
    message.readIDs = @[@(self.senderID)];
    message.dialogID = self.dialog.ID;
    message.dateSent = date;
    
    // Sending message.
    [[QMServicesManager instance].chatService sendMessage:message
                                               toDialogID:self.dialog.ID
                                            saveToHistory:YES
                                            saveToStorage:YES
                                               completion:^(NSError *error) {
                                                   
                                                   if (error != nil) {
                                                       
                                                       [FTIndicator showNotificationWithImage:[UIImage imageNamed:@"ic_notification"]
                                                                                        title:APP_NAME
                                                                                      message:error.localizedDescription];
                                                       
                                                   }
                                               }];
    
    [self finishSendingMessageAnimated:YES];
}

- (void)didPressAccessoryButton:(UIButton *)sender {

    if ([GlobalData sharedInstance].g_selfUser.user_gender.integerValue == UserGenderMale) {
        
        if (![GlobalData sharedInstance].g_bVIPUser) {
            
            [self gotoVIPScreen];
            return;
        }
    }

    [super didPressAccessoryButton:sender];
}

- (void) didPickAttachmentImage:(UIImage *)image {
    
    TOCropViewController *cropVC = [[TOCropViewController alloc] initWithImage:image];
    cropVC.delegate = self;
    [self presentViewController:cropVC animated:YES completion:nil];
}

# pragma mark - CropViewController Delegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    
    QBChatMessage *message = [QBChatMessage new];
    message.senderID = self.senderID;
    message.dialogID = self.dialog.ID;
    message.dateSent = [NSDate date];
    
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __typeof(weakSelf)strongSelf = weakSelf;

        dispatch_async(dispatch_get_main_queue(), ^{
            [[QMServicesManager instance].chatService sendAttachmentMessage:message
                                                                   toDialog:strongSelf.dialog
                                                        withAttachmentImage:image
                                                                 completion:^(NSError *error) {
                                                                     
                                                                     [strongSelf.attachmentCells removeObjectForKey:message.ID];
                                                                     
                                                                     if (error != nil) {
                                                                         [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                                         
                                                                         // perform local attachment deleting
                                                                         [[QMServicesManager instance].chatService deleteMessageLocally:message];
                                                                         [strongSelf.chatSectionManager deleteMessage:message];
                                                                     }
                                                                 }];
            
            [cropViewController dismissViewControllerAnimated:YES completion:nil];
        });
    });
    
}

#pragma mark - Cell classes

- (Class)viewClassForItem:(QBChatMessage *)item {
    
    if (item.isNotificatonMessage) {
        
        return [QMChatNotificationCell class];
    }
    
    if (item.isMediaMessage && item.attachmentStatus != QMMessageAttachmentStatusError) {
        return [CCChatAttachmentCell class];
    }
    else {
        return [CCChatTextCell class];
    }
}

#pragma mark - Strings builder

- (NSAttributedString *)attributedStringForItem:(QBChatMessage *)messageItem {
    
    UIColor *textColor;
    
    if (messageItem.isNotificatonMessage) {
        textColor =  [UIColor blackColor];
    }
    else {
        textColor = [UIColor blackColor];
    }
    
    UIFont *font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:16.0f] ;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.0;
    paragraphStyle.minimumLineHeight = font.lineHeight;
    paragraphStyle.maximumLineHeight = font.lineHeight;
    
    NSDictionary *attributes = @{ NSForegroundColorAttributeName:textColor,
                                  NSFontAttributeName:font,
                                  NSParagraphStyleAttributeName: paragraphStyle};
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:messageItem.text ? messageItem.text : @"" attributes:attributes];
    
    return attrStr;
}

- (NSAttributedString *)topLabelAttributedStringForItem:(QBChatMessage *)messageItem {
    
    UIFont *font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:20.0f];
    UIColor *color = [messageItem senderID] == self.senderID ? [@"#ff0486" representedColor] : [@"#047cff" representedColor];
    
    NSString *topLabelText = [messageItem senderID] == self.senderID ? @"Me" : self.dialog.name;
    
    // setting the paragraph style lineBreakMode to NSLineBreakByTruncatingTail in order to TTTAttributedLabel cut the line in a correct way
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *attributes = @{ NSForegroundColorAttributeName:color,
                                  NSFontAttributeName:font,
                                  NSParagraphStyleAttributeName: paragraphStyle};
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:topLabelText attributes:attributes];
    
    return attrStr;
}

- (NSAttributedString *)bottomLabelAttributedStringForItem:(QBChatMessage *)messageItem {
    
    UIColor *textColor = [UIColor colorWithWhite:0 alpha:0.7f];
    UIFont *font = [UIFont systemFontOfSize:13.0f];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    paragraphStyle.minimumLineHeight = font.lineHeight;
    paragraphStyle.maximumLineHeight = font.lineHeight;
    
    NSDictionary *attributes = @{ NSForegroundColorAttributeName:textColor,
                                  NSFontAttributeName:font,
                                  NSParagraphStyleAttributeName: paragraphStyle};
    
    NSString *text = messageItem.dateSent ? [self timeStampWithDate:messageItem.dateSent] : @"";
    //    if ([messageItem senderID] == self.senderID) {
    //        text = [NSString stringWithFormat:@"%@\n%@", text, [self.stringBuilder statusFromMessage:messageItem]];
    //    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text
                                                                                attributes:attributes];
    
    return attrStr;
}

#pragma mark - Collection View Datasource

- (UICollectionReusableView *)collectionView:(QMChatCollectionView *)collectionView
                    sectionHeaderAtIndexPath:(NSIndexPath *)indexPath {
    CCChatHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                        withReuseIdentifier:[CCChatHeaderCollectionReusableView cellReuseIdentifier] forIndexPath:indexPath];
    
    QMChatSection *chatSection = [self.chatSectionManager chatSectionAtIndex:indexPath.section];
    headerView.headerLabel.text = [[self nameForSectionWithDate:[chatSection lastMessageDate]] uppercaseString];
    headerView.transform = self.collectionView.transform;
    
    return headerView;
}

- (UICollectionReusableView *)collectionView:(QMChatCollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionFooter) {
        // due to collection view being reversed, section header is actually footer
        return [self collectionView:collectionView sectionHeaderAtIndexPath:indexPath];
    }
    
    return nil;
}

- (CGSize)collectionView:(QMChatCollectionView *)collectionView dynamicSizeAtIndexPath:(NSIndexPath *)indexPath maxWidth:(CGFloat)maxWidth {
    
    QBChatMessage *item = [self.chatSectionManager messageForIndexPath:indexPath];
    Class viewClass = [self viewClassForItem:item];
    CGSize size = CGSizeZero;
    
    if (viewClass == [CCChatAttachmentCell class]) {
        
        size = CGSizeMake(MIN(200, maxWidth), 200);
        
    }
    else if (viewClass == [QMChatNotificationCell class]) {
        
        NSAttributedString *attributedString = [self attributedStringForItem:item];
        
        size = [TTTAttributedLabel sizeThatFitsAttributedString:attributedString
                                                withConstraints:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                         limitedToNumberOfLines:0];
    }
    else {
        
        NSAttributedString *attributedString = [self attributedStringForItem:item];
        
        size = [TTTAttributedLabel sizeThatFitsAttributedString:attributedString
                                                withConstraints:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                         limitedToNumberOfLines:0];
        
        size.width += kMarkSpace;
    }
    
    return size;
}

- (CGFloat)collectionView:(QMChatCollectionView *)collectionView minWidthAtIndexPath:(NSIndexPath *)indexPath {
    
    QBChatMessage *item = [self.chatSectionManager messageForIndexPath:indexPath];
    
    CGSize size = CGSizeZero;
    if ([self.detailedCells containsObject:item.ID]) {
        
        size = [TTTAttributedLabel sizeThatFitsAttributedString:[self bottomLabelAttributedStringForItem:item]
                                                withConstraints:CGSizeMake(CGRectGetWidth(self.collectionView.frame) - widthPadding, CGFLOAT_MAX)
                                         limitedToNumberOfLines:0];
    }
    
    CGSize topLabelSize = [TTTAttributedLabel sizeThatFitsAttributedString:[self topLabelAttributedStringForItem:item]
                                                           withConstraints:CGSizeMake(CGRectGetWidth(self.collectionView.frame) - widthPadding, CGFLOAT_MAX)
                                                    limitedToNumberOfLines:0];
    
    if (topLabelSize.width > size.width) {
        size = topLabelSize;
    }
    
    return size.width;
}

/**
 * Allows to perform copy action for QMChatIncomingCell and QMChatOutgoingCell
 */
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
    QBChatMessage *item = [self.chatSectionManager messageForIndexPath:indexPath];
    Class viewClass = [self viewClassForItem:item];
    
    if (viewClass == [QMChatNotificationCell class]
        || viewClass == [QMChatContactRequestCell class]){
        
        return NO;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

/**
 * Allows to perform copy action for QMChatIncomingCell and QMChatOutgoingCell
 */
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
    if (action == @selector(copy:)) {
        
        QBChatMessage *message = [self.chatSectionManager messageForIndexPath:indexPath];
        
        if ([message isMediaMessage]) {
            
            [[QMServicesManager instance].chatService.chatAttachmentService localImageForAttachmentMessage:message completion:^(NSError *error, UIImage *image) {
                if (image) {
                    
                    [[UIPasteboard generalPasteboard] setValue:UIImageJPEGRepresentation(image, 1)
                                             forPasteboardType:(NSString *)kUTTypeJPEG];
                }
            }];
            
        }
        else {
            [[UIPasteboard generalPasteboard] setString:message.text];
        }
    }
}

#pragma mark - Utility

- (NSString *)timeStampWithDate:(NSDate *)date {
    
    static NSDateFormatter *dateFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
    });
    
    NSString *timeStamp = [dateFormatter stringFromDate:date];
    
    return timeStamp;
}

#pragma mark - QMChatCollectionViewDelegateFlowLayout

- (QMChatCellLayoutModel)collectionView:(QMChatCollectionView *)collectionView layoutModelAtIndexPath:(NSIndexPath *)indexPath {
    QMChatCellLayoutModel layoutModel = [super collectionView:collectionView layoutModelAtIndexPath:indexPath];
    
    layoutModel.avatarSize = (CGSize){0.0, 0.0};
    layoutModel.topLabelHeight = 0.0f;
    layoutModel.maxWidthMarginSpace = 20.0f;
    
    QBChatMessage *item = [self.chatSectionManager messageForIndexPath:indexPath];
    Class class = [self viewClassForItem:item];
    
    if (class == [CCChatAttachmentCell class] ||
        class == [CCChatTextCell class]) {
        
        NSAttributedString *topLabelString = [self topLabelAttributedStringForItem:item];
        CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:topLabelString
                                                       withConstraints:CGSizeMake(CGRectGetWidth(self.collectionView.frame) - widthPadding, CGFLOAT_MAX)
                                                limitedToNumberOfLines:1];
        layoutModel.topLabelHeight = size.height;
        layoutModel.spaceBetweenTopLabelAndTextView = 5.0f;
    }
    else if (class == [QMChatNotificationCell class]) {
        
        layoutModel.spaceBetweenTopLabelAndTextView = 5.0f;
    }
    
    CGSize size = CGSizeZero;
    if ([self.detailedCells containsObject:item.ID]) {
        NSAttributedString *bottomAttributedString = [self bottomLabelAttributedStringForItem:item];
        size = [TTTAttributedLabel sizeThatFitsAttributedString:bottomAttributedString
                                                withConstraints:CGSizeMake(CGRectGetWidth(self.collectionView.frame) - widthPadding, CGFLOAT_MAX)
                                         limitedToNumberOfLines:0];
    }
    layoutModel.bottomLabelHeight = ceilf(size.height);
    
    layoutModel.spaceBetweenTextViewAndBottomLabel = 5.0f;
    
    return layoutModel;
}

- (void)collectionView:(QMChatCollectionView *)collectionView configureCell:(UICollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    [super collectionView:collectionView configureCell:cell forIndexPath:indexPath];
    
    QMChatCell *chatCell = (QMChatCell *)cell;
    
    // subscribing to cell delegate
    [chatCell setDelegate:self];
    
    [chatCell containerView].highlightColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    if ([cell isKindOfClass:[CCChatTextCell class]] || [cell isKindOfClass:[CCChatAttachmentCell class]]) {
        
        [chatCell containerView].bgColor = [UIColor clearColor];
        
        ///////////////
        if ([cell isKindOfClass:[CCChatTextCell class]]) {
            
            QBChatMessage *message = [self.chatSectionManager messageForIndexPath:indexPath];
            CCChatTextCell *textCell = (CCChatTextCell *) cell;
            if (message.senderID == self.senderID) {
                
                textCell.senderType = ChatSenderTypeMe;
            }
            else {
                textCell.senderType = ChatSenderTypeOther;
            }
        }
        else {
            
            CCChatAttachmentCell *attachmentCell = (CCChatAttachmentCell *) cell;
            attachmentCell.attachmentImageView.image = [UIImage imageNamed:@"img_default"];
        }
        //////////////
    }
    else if ([cell isKindOfClass:[QMChatNotificationCell class]]) {
        
        [chatCell containerView].bgColor = self.collectionView.backgroundColor;
        // avoid tapping for Notification Cell
        cell.userInteractionEnabled = NO;
    }
    
    if (![cell conformsToProtocol:@protocol(QMChatAttachmentCell)]) {
        return;
    }
    
    QBChatMessage *message = [self.chatSectionManager messageForIndexPath:indexPath];
    
    if (message.attachments == nil) {
        return;
    }
    QBChatAttachment *attachment = message.attachments.firstObject;
    
    NSMutableArray *keysToRemove = [NSMutableArray array];
    
    NSEnumerator *enumerator = [self.attachmentCells keyEnumerator];
    NSString *existingAttachmentID = nil;
    while (existingAttachmentID = [enumerator nextObject]) {
        UICollectionViewCell *cachedCell = [self.attachmentCells objectForKey:existingAttachmentID];
        if ([cachedCell isEqual:cell]) {
            [keysToRemove addObject:existingAttachmentID];
        }
    }
    
    for (NSString *key in keysToRemove) {
        [self.attachmentCells removeObjectForKey:key];
    }
    
    [self.attachmentCells setObject:cell forKey:attachment.ID];
    [(id<QMChatAttachmentCell>)cell setAttachmentID:attachment.ID];
    
    __weak typeof(self)weakSelf = self;
    // Getting image from chat attachment service.
    [[QMServicesManager instance].chatService.chatAttachmentService imageForAttachmentMessage:message completion:^(NSError *error, UIImage *image) {
        //
        
        if ([(id<QMChatAttachmentCell>)cell attachmentID] != attachment.ID) return;
        
        [weakSelf.attachmentCells removeObjectForKey:attachment.ID];
        
        if (error != nil) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        } else {
            if (image != nil) {
                [(id<QMChatAttachmentCell>)cell setAttachmentImage:image];
                [cell updateConstraints];
            }
        }
    }];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger lastSection = [self.collectionView numberOfSections] - 1;
    if (indexPath.section == lastSection && indexPath.item == [self.collectionView numberOfItemsInSection:lastSection] - 1) {
        // the very first message
        // load more if exists
        __weak typeof(self)weakSelf = self;
        // Getting earlier messages for chat dialog identifier.
        [[[QMServicesManager instance].chatService loadEarlierMessagesWithChatDialogID:self.dialog.ID] continueWithBlock:^id(BFTask *task) {
            
            if ([task.result count] > 0) {
                
                // remove old message
                QBChatMessage *lastMessage = [task.result lastObject];
                if ([NSDate daysBetweenDate:lastMessage.dateSent andDate:[NSDate date]] >= CHAT_HISTORY_LIMIT) {
                    
                    [[QMServicesManager instance].chatService deleteMessagesLocally:task.result
                                                                        forDialogID:self.dialog.ID];
                }
                else {
                
                    [weakSelf.chatSectionManager addMessages:task.result];
                }
            }
            
            return nil;
        }];
    }
    
    // marking message as read if needed
    QBChatMessage *itemMessage = [self.chatSectionManager messageForIndexPath:indexPath];
    [self sendReadStatusForMessage:itemMessage];
    
    return [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

#pragma mark - QMChatCellDelegate

- (void)chatCellDidTapContainer:(QMChatCell *)cell {
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    QBChatMessage *currentMessage = [self.chatSectionManager messageForIndexPath:indexPath];
    
    if ([self.detailedCells containsObject:currentMessage.ID]) {
        [self.detailedCells removeObject:currentMessage.ID];
    } else {
        [self.detailedCells addObject:currentMessage.ID];
    }
    
    [self.collectionView.collectionViewLayout removeSizeFromCacheForItemID:currentMessage.ID];
    [self.collectionView performBatchUpdates:nil completion:nil];
}

- (void)chatCell:(QMChatCell *)__unused cell didTapOnTextCheckingResult:(NSTextCheckingResult *)textCheckingResult {
    
    switch (textCheckingResult.resultType) {
            
        case NSTextCheckingTypeLink: {
            
            if ([SFSafariViewController class] != nil &&
                // SFSafariViewController supporting only http and https schemes
                ([textCheckingResult.URL.scheme.lowercaseString isEqualToString:@"http"]
                 || [textCheckingResult.URL.scheme.lowercaseString isEqualToString:@"https"])) {
                    
                    SFSafariViewController *controller = [[SFSafariViewController alloc] initWithURL:textCheckingResult.URL entersReaderIfAvailable:false];
                    [self presentViewController:controller animated:true completion:nil];
                    
                }
            else {
                
                if ([[UIApplication sharedApplication] canOpenURL:textCheckingResult.URL]) {
                    
                    [[UIApplication sharedApplication] openURL:textCheckingResult.URL];
                }
            }
            
            break;
        }
            
        case NSTextCheckingTypePhoneNumber: {
            
            
            if (![self canMakeACall]) {
                
                SHOW_INFO_MESSAGE(@"Your Device can't make a phone call");
                break;
            }
            
            NSString *urlString = [NSString stringWithFormat:@"tel:%@", textCheckingResult.phoneNumber];
            NSURL *url = [NSURL URLWithString:urlString];
            
            [self.view endEditing:YES];
            
            void (^callAction)(void) = ^ {
                
                [[UIApplication sharedApplication] openURL:url];
            };
            
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:nil
                                                  message:textCheckingResult.phoneNumber
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"SA_STR_CANCEL", nil)
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * _Nonnull __unused action) {
                                                              }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"SA_STR_CALL", nil)
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull __unused action) {
                                                                  
                                                                  callAction();
                                                                  
                                                              }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)chatCell:(QMChatCell *)cell didPerformAction:(SEL)action withSender:(id)sender {
    
}

- (void)chatCellDidTapAvatar:(QMChatCell *)cell {
    
}

- (void)chatCell:(QMChatCell *)cell didTapAtPosition:(CGPoint)position {
    
}

#pragma mark - QMChatServiceDelegate

- (void)chatService:(QMChatService *)chatService didLoadMessagesFromCache:(NSArray *)messages forDialogID:(NSString *)dialogID {
    
    if ([self.dialog.ID isEqualToString:dialogID]) {
        
        [self.chatSectionManager addMessages:messages];
    }
}

- (void)chatService:(QMChatService *)chatService didAddMessageToMemoryStorage:(QBChatMessage *)message forDialogID:(NSString *)dialogID {
    
    if ([self.dialog.ID isEqualToString:dialogID]) {
        // Inserting message received from XMPP or self sent
        [self.chatSectionManager addMessage:message];
    }
}

- (void)chatService:(QMChatService *)chatService didUpdateChatDialogInMemoryStorage:(QBChatDialog *)chatDialog {
    
    if ([self.dialog.ID isEqualToString:chatDialog.ID]) {
        self.dialog  = chatDialog;
        self.title = self.dialog.name;
    }
}

- (void)chatService:(QMChatService *)chatService didUpdateMessage:(QBChatMessage *)message forDialogID:(NSString *)dialogID {
    
    if ([self.dialog.ID isEqualToString:dialogID] && message.senderID == self.senderID) {
        
        [self.chatSectionManager updateMessage:message];
    }
}

- (void)chatService:(QMChatService *)chatService didUpdateMessages:(NSArray *)messages forDialogID:(NSString *)dialogID {
    
    if ([self.dialog.ID isEqualToString:dialogID]) {
        
        [self.chatSectionManager updateMessages:messages];
    }
}

#pragma mark - QMChatConnectionDelegate

- (void)refreshAndReadMessages; {
    
    [self refreshMessagesShowingProgress:YES];
    
    if (self.unreadMessages.count > 0) {
        [self readMessages:self.unreadMessages];
    }
    
    self.unreadMessages = nil;
}

- (void)chatServiceChatDidConnect:(QMChatService *)chatService {
    
    [self refreshAndReadMessages];
}

- (void)chatServiceChatDidReconnect:(QMChatService *)chatService {
    
    [self refreshAndReadMessages];
}

#pragma mark - QMChatAttachmentServiceDelegate

- (void)chatAttachmentService:(QMChatAttachmentService *)chatAttachmentService didChangeAttachmentStatus:(QMMessageAttachmentStatus)status forMessage:(QBChatMessage *)message {
    
    if (status != QMMessageAttachmentStatusNotLoaded) {
        
        if ([message.dialogID isEqualToString:self.dialog.ID]) {
            
            [self.chatSectionManager updateMessage:message];
        }
    }
}

- (void)chatAttachmentService:(QMChatAttachmentService *)chatAttachmentService didChangeLoadingProgress:(CGFloat)progress forChatAttachment:(QBChatAttachment *)attachment {
    
    id<QMChatAttachmentCell> cell = [self.attachmentCells objectForKey:attachment.ID];
    if (cell != nil) {
        
        [cell updateLoadingProgress:progress];
    }
}

- (void)chatAttachmentService:(QMChatAttachmentService *)chatAttachmentService didChangeUploadingProgress:(CGFloat)progress forMessage:(QBChatMessage *)message {
    
    id<QMChatAttachmentCell> cell = [self.attachmentCells objectForKey:message.ID];
    
    if (cell == nil && progress < 1.0f) {
        
        NSIndexPath *indexPath = [self.chatSectionManager indexPathForMessage:message];
        cell = (UICollectionViewCell <QMChatAttachmentCell> *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [self.attachmentCells setObject:cell forKey:message.ID];
    }
    
    if (cell != nil) {
        
        [cell updateLoadingProgress:progress];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {

    if ([GlobalData sharedInstance].g_selfUser.user_gender.integerValue == UserGenderMale) {
        
        if (![GlobalData sharedInstance].g_bVIPUser) {
            
            [self gotoVIPScreen];
            
            return NO;
        }
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    [super textViewDidChange:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([((QMPlaceHolderTextView*)textView) hasTextAttachment]) {
        if (text.length == 0)
        {
            [((QMPlaceHolderTextView*)textView) setDefaultSettings];
            return YES;
        }
        return NO;
    }
    
    // Prevent crashing undo bug
    if(range.length + range.location > textView.text.length)
    {
        return NO;
    }
    
    if (![QMServicesManager instance].isAuthorized) {
        
        return YES;
    }
    
    if (self.typingTimer) {
        
        [self.typingTimer invalidate];
        self.typingTimer = nil;
    } else {
        
        [self.dialog sendUserIsTyping];
    }
    
    self.typingTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(fireStopTypingIfNecessary) userInfo:nil repeats:NO];
    
    if (maxCharactersNumber > 0) {
        
        if (textView.text.length >= maxCharactersNumber && text.length > 0) {
            [self showCharactersNumberError];
            return NO;
        }
        
        NSString * newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
        
        if ([newText length] <= maxCharactersNumber || text.length == 0) {
            return YES;
        }
        
        
        NSInteger symbolsToCut = maxCharactersNumber - textView.text.length;
        
        NSRange stringRange = {0, MIN([text length], symbolsToCut)};
        
        // adjust the range to include dependent chars
        stringRange = [text rangeOfComposedCharacterSequencesForRange:stringRange];
        
        // Now you can create the short string
        NSString *shortString = [text substringWithRange:stringRange];
        
        NSMutableString * newtext = textView.text.mutableCopy;
        [newtext insertString:shortString atIndex:range.location];
        
        textView.text = newtext.copy;
        
        [self showCharactersNumberError];
        
        [self textViewDidChange:textView];
        
        return NO;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [super textViewDidEndEditing:textView];
    
    [self fireStopTypingIfNecessary];
}

- (BOOL)placeHolderTextView:(QMPlaceHolderTextView *)textView shouldPasteWithSender:(id)sender {
    
    if ([UIPasteboard generalPasteboard].image) {
        
        /* Variant 2*/
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIPasteboard generalPasteboard].image;
        textAttachment.bounds = CGRectMake(0, 0, 100, 100);
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [self.inputToolbar.contentView.textView setAttributedText:attrStringWithImage];
        [self textViewDidChange:self.inputToolbar.contentView.textView];
        
        return NO;
    }
    return YES;
}

- (BOOL)canMakeACall {
    BOOL canMakeACall = false;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
        // Check if iOS Device supports phone calls
        CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [netInfo subscriberCellularProvider];
        NSString *mnc = [carrier mobileNetworkCode];
        // User will get an alert error when they will try to make a phone call in airplane mode.
        if (([mnc length] == 0)) {
            // Device cannot place a call at this time.  SIM might be removed.
        } else {
            // iOS Device is capable for making calls
            canMakeACall = true;
        }
    } else {
        // iOS Device is not capable for making calls
    }
    return canMakeACall;
}

- (void)showCharactersNumberError {
    
    NSString * subtitle = [NSString stringWithFormat:@"The character limit is %lu. ", (unsigned long)maxCharactersNumber];
    
    [FTIndicator showNotificationWithImage:[UIImage imageNamed:@"ic_notification"]
                                     title:APP_NAME
                                   message:subtitle];
    
}

# pragma mark - VIP Screen Handler

- (void) gotoVIPScreen {
    
    // show vip view controller
    UIViewController *vipVC = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"CCVIPViewController"];
    [self.self.parentViewController.navigationController pushViewController:vipVC animated:YES];
}

@end
