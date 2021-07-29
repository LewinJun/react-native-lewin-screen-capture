//
//  ScreenCapture.m
//  ScreenCapture
//
//  Created by lewin on 2018/10/11.
//  Copyright © 2018年 lewin. All rights reserved.
//

#import "ScreenCapture.h"
#import <UIKit/UIKit.h>
#import "UIView+ComOpenThreadOTScreenshotHelperStatusBarReference.h"
#import <QuartzCore/QuartzCore.h>

#define PATH @"lewin-screen-capture"

@implementation ScreenCapture
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(startListener:(RCTPromiseResolveBlock)success failure:(RCTResponseErrorBlock)failure){
    dispatch_sync(dispatch_get_main_queue(), ^{
        @try{
            [self startListener];
            success(@"true");
        }@catch(NSException *ex){
            NSString *domain = @"lewin.error";
            NSString *desc = NSLocalizedString(@"开启失败", @"");
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
            NSError *error = [NSError errorWithDomain:domain
                                                 code:404
                                             userInfo:userInfo];
            failure(error);
        }
    });
}

RCT_EXPORT_METHOD(screenCapture:(BOOL)isHiddenStatus extension:(nonnull NSString*)extension quality:(nonnull NSNumber*)quality success:(RCTPromiseResolveBlock)success failure:(RCTResponseErrorBlock)failure){
    dispatch_sync(dispatch_get_main_queue(), ^{
        @try{
            success([self screenImage: isHiddenStatus extension:extension quality:quality]);
        }@catch(NSException *ex){
            NSString *domain = @"lewin.error";
            NSString *desc = NSLocalizedString(@"开启失败", @"");
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
            NSError *error = [NSError errorWithDomain:domain
                                                 code:404
                                             userInfo:userInfo];
            failure(error);
        }
    });
}

RCT_EXPORT_METHOD(stopListener:(RCTPromiseResolveBlock)success failure:(RCTResponseErrorBlock)failure){
    dispatch_sync(dispatch_get_main_queue(), ^{
        @try{
            [self stopListener];
            success(@"true");
        }@catch(NSException *ex){
            NSString *domain = @"lewin.error";
            NSString *desc = NSLocalizedString(@"开启失败", @"");
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
            NSError *error = [NSError errorWithDomain:domain
                                                 code:404
                                             userInfo:userInfo];
            failure(error);
        }
    });
}

RCT_EXPORT_METHOD(clearCache:(RCTPromiseResolveBlock)success failure:(RCTResponseErrorBlock)failure){
    dispatch_sync(dispatch_get_main_queue(), ^{
        @try{
            NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *path =[[paths objectAtIndex:0]stringByAppendingPathComponent:PATH];
            NSLog(@"count: %lu", [[fileManager enumeratorAtPath:path].allObjects count]);
            if ([fileManager removeItemAtPath:path error:NULL]) {
                success(@{@"code": @"200"});
                NSLog(@"delete count: %lu", [[fileManager enumeratorAtPath:path].allObjects count]);
            }else {
                NSLog(@"delete fail: %lu", [[fileManager enumeratorAtPath:path].allObjects count]);
                success(@{@"code": @"500", @"errMsg":@"删除失败"});
            }
        }@catch(NSException *ex){
            NSString *domain = @"lewin.error";
            NSString *desc = NSLocalizedString(@"开启失败", @"");
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
            NSError *error = [NSError errorWithDomain:domain
                                                 code:404
                                             userInfo:userInfo];
            failure(error);
        }
    });
}

- (void) startListener {
//    AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getScreenshot:)
                                                 name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void) stopListener {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

-(NSArray<NSString *> *)supportedEvents {
    return @[@"ScreenCapture"];
}

- (void)getScreenshot:(NSNotification *)notification{
    NSLog(@"捕捉截屏事件");

//    CGSize imageSize = CGSizeZero;
//     imageSize = [UIScreen mainScreen].bounds.size;

//     UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
//     CGContextRef context = UIGraphicsGetCurrentContext();
//     for (UIWindow *window in [[UIApplication sharedApplication] windows])
//     {
//         CGContextSaveGState(context);
//         CGContextTranslateCTM(context, window.center.x, window.center.y);
//         CGContextConcatCTM(context, window.transform);
//         CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
//                 if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
//         {
//             [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
//         }
//         else
//         {
//             [window.layer renderInContext:context];
//         }
//         CGContextRestoreGState(context);
//     }
    [self sendEventWithName:@"ScreenCapture" body:[self screenImage:NO extension:@"png" quality:[NSNumber numberWithInt:100]]];
}

- (NSDictionary*) screenImage:(BOOL)isHiddenStatus extension:(NSString*)extension quality:(NSNumber*)quality {
    @try{
        UIImage *image = isHiddenStatus ? [self screenshotWithStatusBar:false] : [self screenshot];
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *path =[[paths objectAtIndex:0]stringByAppendingPathComponent:PATH];
        if (![fileManager fileExistsAtPath:path]) {
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        long time = (long)[[NSDate new] timeIntervalSince1970];
        NSString *filePath = @"";
        if ([extension isEqualToString:@"jpeg"]) {
            filePath = [path stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"screen-capture-%ld.jpg", time]];
        } else {
            filePath = [path stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"screen-capture-%ld.png", time]];
        }
        NSString *encodedImageStr = @"";
        @try{
            // UIGraphicsEndImageContext();
            //    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
            // 保存文件的名称
            if ([extension isEqualToString:@"jpeg"]) {
                CGFloat floatQuality = [quality floatValue] / 100.0;
                BOOL result = [UIImageJPEGRepresentation(image, floatQuality)writeToFile:filePath atomically:YES]; // 保存成功会返回YES
                if (result == YES) {
                    NSLog(@"保存成功");
                }
                encodedImageStr = [UIImageJPEGRepresentation(image, floatQuality) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            } else {
                BOOL result = [UIImagePNGRepresentation(image)writeToFile:filePath atomically:YES]; // 保存成功会返回YES
                if (result == YES) {
                    NSLog(@"保存成功");
                }
                encodedImageStr = [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }
        }@catch(NSException *ex) {
            NSLog(@"保存图片失败：%@", ex.description);
            filePath = @"";
        }
        return @{@"code":@"200", @"base64":encodedImageStr, @"uri":filePath};
    }@catch(NSException *ex) {
        NSLog(@"截屏失败：%@", ex.description);
        return @{@"code":@"500", @"errMsg": @"截屏失败"};
    }
}

- (UIImage *)screenshotOfView:(UIView *)view
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [view bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    // -renderInContext: renders in the coordinate space of the layer,
    // so we must first apply the layer's geometry to the graphics context
    CGContextSaveGState(context);
    // Center the context around the window's anchor point
    CGContextTranslateCTM(context, [view center].x, [view center].y);
    // Apply the view transform about the anchor point
    CGContextConcatCTM(context, [view transform]);
    // Offset by the portion of the bounds left of and above the anchor point
    CGContextTranslateCTM(context,
                          -[view bounds].size.width * [[view layer] anchorPoint].x,
                          -[view bounds].size.height * [[view layer] anchorPoint].y);
    
    // Render the layer hierarchy to the current context
    [[view layer] renderInContext:context];
    
    // Restore the context
    CGContextRestoreGState(context);
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)screenshot
{
    return [self screenshotWithStatusBar:YES];
}

- (UIImage *)screenshotWithStatusBar:(BOOL)withStatusBar
{
    CGRect screenShotRect = [[UIScreen mainScreen] bounds];
    UIInterfaceOrientation o = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(o))
    {
        CGFloat oldWidth = screenShotRect.size.width;
        screenShotRect.size.width = screenShotRect.size.height;
        screenShotRect.size.height = oldWidth;
    }
    return [self screenshotWithStatusBar:withStatusBar rect:screenShotRect];
}

- (UIImage *)screenshotWithStatusBar:(BOOL)withStatusBar rect:(CGRect)rect
{
    UIInterfaceOrientation o = [[UIApplication sharedApplication] statusBarOrientation];
    return [self screenshotWithStatusBar:withStatusBar rect:rect orientation:o];
}

- (UIImage *)screenshotWithStatusBar:(BOOL)withStatusBar rect:(CGRect)rect orientation:(UIInterfaceOrientation)o
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = CGRectGetWidth(screenRect);
    CGFloat screenHeight = CGRectGetHeight(screenRect);
    CGAffineTransform preTransform = CGAffineTransformIdentity;
    switch (o)
    {
        case UIInterfaceOrientationPortrait:
            //move screenshot rect origin to down left
            //rotate screenshot rect to meet portrait
            //move screenshot rect origin to up left
            //....yes, with a single line..
            preTransform = CGAffineTransformTranslate(preTransform, -rect.origin.x, -rect.origin.y);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            //move screenshot rect origin to down left
            preTransform = CGAffineTransformTranslate(preTransform, screenWidth - rect.origin.x, -rect.origin.y);
            //rotate screenshot rect to meet portrait
            preTransform = CGAffineTransformRotate(preTransform, M_PI);
            //move screenshot rect origin to up left
            preTransform = CGAffineTransformTranslate(preTransform, 0, -screenHeight);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            //move screenshot rect origin to down left
            preTransform = CGAffineTransformTranslate(preTransform, -rect.origin.x, -rect.origin.y);
            //rotate screenshot rect to meet portrait
            preTransform = CGAffineTransformRotate(preTransform, M_PI_2);
            //move screenshot rect origin to up left
            preTransform = CGAffineTransformTranslate(preTransform, 0, -screenHeight);
            break;
        case UIInterfaceOrientationLandscapeRight:
            //move screenshot rect origin to down left
            preTransform = CGAffineTransformTranslate(preTransform, screenHeight - rect.origin.x, screenWidth - rect.origin.y);
            //rotate screenshot rect to meet portrait
            preTransform = CGAffineTransformRotate(preTransform, - M_PI_2);
            //move screenshot rect origin to up left
            preTransform = CGAffineTransformTranslate(preTransform, 0, -screenHeight);
            break;
        default:
            break;
    }
    
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    if (NULL != UIGraphicsBeginImageContextWithOptions)
    {
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    }
    else
    {
        UIGraphicsBeginImageContext(rect.size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    BOOL hasTakenStatusBarScreenshot = NO;
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            
            // Apply pre tranform to context.
            // to convert all interface orientation situation to portrait situation.
            CGContextConcatCTM(context, preTransform);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
        
        // Screenshot status bar if next window's window level > status bar window level
        NSArray *windows = [[UIApplication sharedApplication] windows];
        NSUInteger currentWindowIndex = [windows indexOfObject:window];
        if (windows.count > currentWindowIndex - 1)
        {
            UIWindow *nextWindow = [windows objectAtIndex:currentWindowIndex - 1];
            if (withStatusBar && nextWindow.windowLevel > UIWindowLevelStatusBar && !hasTakenStatusBarScreenshot)
            {
                [self mergeStatusBarToContext:context rect:rect screenshotOrientation:o];
                hasTakenStatusBarScreenshot = YES;
            }
        }
        else
        {
            if (withStatusBar && !hasTakenStatusBarScreenshot)
            {
                [self mergeStatusBarToContext:context rect:rect screenshotOrientation:o];
                hasTakenStatusBarScreenshot = YES;
            }
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)mergeStatusBarToContext:(CGContextRef)context
                           rect:(CGRect)rect
          screenshotOrientation:(UIInterfaceOrientation)o
{
    UIView *statusBarView = [UIView statusBarInstance_ComOpenThreadOTScreenshotHelper];
    UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGAffineTransform preTransform = CGAffineTransformIdentity;
    if (o == statusBarOrientation)
    {
        preTransform = CGAffineTransformTranslate(preTransform, -rect.origin.x, -rect.origin.y);
    }
    //Handle status bar orientation in portrait and portrait upside down screen shot
    else if((o == UIInterfaceOrientationPortrait && statusBarOrientation == UIInterfaceOrientationLandscapeLeft) ||
            (o == UIInterfaceOrientationPortraitUpsideDown && statusBarOrientation == UIInterfaceOrientationLandscapeRight))
    {
        preTransform = CGAffineTransformTranslate(preTransform, 0, rect.size.height);
        preTransform = CGAffineTransformRotate(preTransform, - M_PI_2);
        preTransform = CGAffineTransformTranslate(preTransform, CGRectGetMaxY(rect) - screenHeight, -rect.origin.x);
    }
    else if((o == UIInterfaceOrientationPortrait && statusBarOrientation == UIInterfaceOrientationLandscapeRight) ||
            (o == UIInterfaceOrientationPortraitUpsideDown && statusBarOrientation == UIInterfaceOrientationLandscapeLeft))
    {
        preTransform = CGAffineTransformTranslate(preTransform, 0, rect.size.height);
        preTransform = CGAffineTransformRotate(preTransform, M_PI_2);
        preTransform = CGAffineTransformTranslate(preTransform, -CGRectGetMaxY(rect), rect.origin.x - screenWidth);
    }
    else if((o == UIInterfaceOrientationPortrait && statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) ||
            (o == UIInterfaceOrientationPortraitUpsideDown && statusBarOrientation == UIInterfaceOrientationPortrait))
    {
        preTransform = CGAffineTransformTranslate(preTransform, 0, rect.size.height);
        preTransform = CGAffineTransformRotate(preTransform, - M_PI);
        preTransform = CGAffineTransformTranslate(preTransform, rect.origin.x - screenWidth, CGRectGetMaxY(rect) - screenHeight);
    }
    //Handle status bar orientation in landscape left and landscape right screen shot
    else if((o == UIInterfaceOrientationLandscapeLeft && statusBarOrientation == UIInterfaceOrientationPortrait) ||
            (o == UIInterfaceOrientationLandscapeRight && statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        preTransform = CGAffineTransformTranslate(preTransform, 0, rect.size.height);
        preTransform = CGAffineTransformRotate(preTransform, M_PI_2);
        preTransform = CGAffineTransformTranslate(preTransform, -CGRectGetMaxY(rect), rect.origin.x - screenHeight);
    }
    else if((o == UIInterfaceOrientationLandscapeLeft && statusBarOrientation == UIInterfaceOrientationLandscapeRight) ||
            (o == UIInterfaceOrientationLandscapeRight && statusBarOrientation == UIInterfaceOrientationLandscapeLeft))
    {
        preTransform = CGAffineTransformTranslate(preTransform, 0, rect.size.height);
        preTransform = CGAffineTransformRotate(preTransform, M_PI);
        preTransform = CGAffineTransformTranslate(preTransform, rect.origin.x - screenHeight, CGRectGetMaxY(rect) - screenWidth);
    }
    else if((o == UIInterfaceOrientationLandscapeLeft && statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) ||
            (o == UIInterfaceOrientationLandscapeRight && statusBarOrientation == UIInterfaceOrientationPortrait))
    {
        preTransform = CGAffineTransformTranslate(preTransform, 0, rect.size.height);
        preTransform = CGAffineTransformRotate(preTransform, - M_PI_2);
        preTransform = CGAffineTransformTranslate(preTransform, CGRectGetMaxY(rect) - screenWidth, -rect.origin.x);
    }
    
    // -renderInContext: renders in the coordinate space of the layer,
    // so we must first apply the layer's geometry to the graphics context
    CGContextSaveGState(context);
    // Apply pre transform
    CGContextConcatCTM(context, preTransform);
    // Center the context around the window's anchor point
    CGContextTranslateCTM(context, [statusBarView center].x, [statusBarView center].y);
    // Apply the view transform about the anchor point
    CGContextConcatCTM(context, [statusBarView transform]);
    // Offset by the portion of the bounds left of and above the anchor point
    CGContextTranslateCTM(context,
                          -[statusBarView bounds].size.width * [[statusBarView layer] anchorPoint].x,
                          -[statusBarView bounds].size.height * [[statusBarView layer] anchorPoint].y);
    
    // Render the layer hierarchy to the current context
    [[statusBarView layer] renderInContext:context];
    
    // Restore the context
    CGContextRestoreGState(context);
}

@end
