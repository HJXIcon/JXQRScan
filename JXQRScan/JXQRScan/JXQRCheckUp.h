//
//  JXQRCheckUp.h
//  text
//
//  Created by yituiyun on 2017/11/3.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXQRCheckUp : NSObject
+ (BOOL)cameraCheckUp;

+ (void)requestCameraCheckUpWithResult:(void(^)(BOOL))completion;

+ (BOOL)photoCheckUp;

@end
