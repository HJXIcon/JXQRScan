//
//  JXQRCheckUp.m
//  text
//
//  Created by yituiyun on 2017/11/3.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "JXQRCheckUp.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@implementation JXQRCheckUp

+ (BOOL)cameraCheckUp
{
    
    BOOL isHavePemission = YES;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                isHavePemission = YES;
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                isHavePemission = NO;
                break;
            case AVAuthorizationStatusNotDetermined:
                isHavePemission = YES;
                break;
        }
    }
    
    return isHavePemission;
}


+ (void)requestCameraCheckUpWithResult:(void(^)(BOOL))completion
{
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                completion(YES);
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                completion(NO);
                break;
            case AVAuthorizationStatusNotDetermined:
            {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                         completionHandler:^(BOOL granted) {
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 if (granted) {
                                                     completion(true);
                                                 } else {
                                                     completion(false);
                                                 }
                                             });
                                             
                                         }];
            }
                break;
                
        }
    }
    
    
}


+ (BOOL)photoCheckUp
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
#pragma mark - lazy load
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];

        if ( author == ALAuthorizationStatusDenied ) {
            
            return NO;
        }
        return YES;
    }
    
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if ( authorStatus == PHAuthorizationStatusDenied ) {
        
        return NO;
    }
    return YES;
}
#pragma clang diagnostic pop
@end
