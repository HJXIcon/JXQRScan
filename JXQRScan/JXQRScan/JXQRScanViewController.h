//
//  JXQRScanViewController.h
//  text
//
//  Created by yituiyun on 2017/11/2.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXQRScanStyle.h"
#import "JXQRScan.h"
#import "JXQRCheckUp.h"
#import "JXQRScanView.h"

@class JXQRScanViewController;
@protocol JXQRScanViewControllerDelegate<NSObject>
@optional

// 扫描结果
- (void)QRScanViewController:(JXQRScanViewController *)vc results:(NSArray <NSString *>*)results;

@end

@interface JXQRScanViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) id<JXQRScanViewControllerDelegate>delegate;

@property (nonatomic, strong) JXQRScanStyle *style;


// 是否双击缩放  默认是yes
@property (nonatomic, assign) BOOL doubleTapScale;
// 缩放比例 必须大于1 默认是3
@property (nonatomic, assign) CGFloat doubleTapScaleValue;

//开关闪光灯
- (void)openOrCloseFlash;

// 打开本地照片，选择图片识别
- (void)openPhotoAndScanImage:(BOOL)allowsEditing;

// 开始
- (void)startScan;
- (void)stopScan;

@end
