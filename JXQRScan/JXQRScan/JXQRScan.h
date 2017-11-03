//
//  JXQRScan.h
//  text
//
//  Created by yituiyun on 2017/11/2.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JXQRScan : NSObject

// 设置是否需要描绘二维码边框
@property (nonatomic, assign) BOOL isDrawQRCodeRect;
@property (nonatomic, strong) UIColor *colorDrawQRCodeRect;
@property (nonatomic, assign) CGFloat drawQRCodeRectWidth;


// 开启关闭闪光灯
@property (nonatomic, assign) BOOL torch;

// 停止扫描
- (void)beginScanInView:(UIView *)view result:(void(^)(NSArray<NSString *> *resultStrs))resultBlock;

// 兴趣点范围
- (void)setInsteretRect:(CGRect)originRect;

// 停止扫描
- (void)stopScan;

// 自动根据闪关灯状态去改变
- (void)openOrCloseFlash;


#pragma mark --镜头
/**
 @brief 获取摄像机最大拉远镜头
 @return 放大系数
 */
- (CGFloat)getVideoMaxScale;

/**
 @brief 拉近拉远镜头
 @param scale 系数
 */
- (void)setVideoScale:(CGFloat)scale;


/**
 识别QR二维码图片,ios8.0以上支持
 
 @param QRImage 图片
 @param success 返回识别结果
 */
+ (void)recognizeQRImage:(UIImage *)QRImage success:(void(^)(NSArray <NSString *> *array))success;

@end
