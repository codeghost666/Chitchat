//
//  CCInstagramActivity.m
//  ChitChat
//
//  Created by Jinjin Lee on 10/18/16.
//  Copyright © 2016 developer. All rights reserved.
//

#import "CCInstagramActivity.h"

@implementation CCInstagramActivity

- (NSString *)activityType {
    
    return @"UIActivityTypePostToInstagram";
}

- (NSString *)activityTitle {
    
    return @"Instagram";
}

- (UIImage *)activityImage {
    
    return [UIImage imageNamed:@"ic_share_instagram"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    
    if (![[UIApplication sharedApplication] canOpenURL:instagramURL]) return NO; // no instagram.
    
    for (UIActivityItemProvider *item in activityItems) {
    
        if ([item isKindOfClass:[UIImage class]]) {
            return YES;
        }
    }
    return NO;
}

- (UIViewController *)activityViewController {
    
    [self performActivity];
    
    return nil;
}

- (void)performActivity
{
    // no resize, just fire away.
    //UIImageWriteToSavedPhotosAlbum(item.image, nil, nil, nil);
    
    CGFloat cropVal = (self.shareImage.size.height > self.shareImage.size.width ? self.shareImage.size.width : self.shareImage.size.height);
    
    cropVal *= [self.shareImage scale];
    
    CGRect cropRect = (CGRect){.size.height = cropVal, .size.width = cropVal};
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.shareImage CGImage], cropRect);
    
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithCGImage:imageRef], 1.0);
    CGImageRelease(imageRef);
    
    NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
    if (![imageData writeToFile:writePath atomically:YES]) {
        // failure
        NSLog(@"image save failed to path %@", writePath);
        [self activityDidFinish:NO];
        return;
    } else {
        // success.
    }
    
    // send it to instagram.
    NSURL *fileURL = [NSURL fileURLWithPath:writePath];
    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    self.documentController.delegate = self;
    [self.documentController setUTI:@"com.instagram.exclusivegram"];
    if (self.shareString) [self.documentController setAnnotation:@{@"InstagramCaption" : self.shareString}];
    
    if (![self.documentController presentOpenInMenuFromBarButtonItem:_barButtonItem animated:YES])
        NSLog(@"couldn't present document interaction controller");
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller
           didEndSendingToApplication:(NSString *)application {
    
    [self activityDidFinish:YES];
}

-(BOOL)imageIsLargeEnough:(UIImage *)image {
    
    CGSize imageSize = [image size];
    return ((imageSize.height * image.scale) >= 612 && (imageSize.width * image.scale) >= 612);
}

-(BOOL)imageIsSquare:(UIImage *)image {
    
    return (image.size.height == image.size.width);
}

-(void)activityDidFinish:(BOOL)success {
    
    NSError *error = nil;
    NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
    if (![[NSFileManager defaultManager] removeItemAtPath:writePath error:&error]) {
        NSLog(@"Error cleaning up temporary image file: %@", error);
    }
    [super activityDidFinish:success];
}


@end
