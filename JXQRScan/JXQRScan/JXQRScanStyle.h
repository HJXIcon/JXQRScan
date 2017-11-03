//
//  JXQRScanViewStyle.h
//  text
//
//  Created by yituiyun on 2017/11/2.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,JXQRScanAnimationStyle)
{
    JXQRScanAnimationStyleLine,   //线条上下移动
    JXQRScanAnimationStyleNet,    //网格
    JXQRScanAnimationStyleNone    //无动画

};

NS_ASSUME_NONNULL_BEGIN

@interface JXQRScanStyle : NSObject


#pragma mark - 兴趣矩形框
// 是否显示矩形框
@property (nonatomic, assign) BOOL isNeedShowRetangle;
// 矩形的左右边距
@property (nonatomic, assign) CGFloat retanglePadding;
/**
 0表示扫码透明区域在当前视图中心位置，< 0 表示扫码区域下移, >0 表示扫码区域上移
 */
@property (nonatomic, assign) CGFloat centerUpOffset; // 默认44
@property (nonatomic, strong) UIColor *colorRetangleLine;

#pragma mark - 扫描时
// 设置是否需要描绘二维码边框
@property (nonatomic, assign) BOOL isDrawQRCodeRect;
@property (nonatomic, strong) UIColor *colorDrawQRCodeRect;
@property (nonatomic, assign) CGFloat drawQRCodeRectWidth;

#pragma mark - 4个角
@property (nonatomic, strong) UIColor *colorAngle;
@property (nonatomic, assign) CGFloat angleW;
@property (nonatomic, assign) CGFloat angleH;
// 线宽
@property (nonatomic, assign) CGFloat angleLineW;




#pragma mark --动画效果
// 扫码动画效果:线条或网格
@property (nonatomic, assign) JXQRScanAnimationStyle anmiationStyle;

/**
 *  动画效果的图像，如线条或网格的图像，如果为nil，表示不需要动画效果
 */
@property (nonatomic,strong,nullable) UIImage *animationImage;



#pragma mark -非识别区域颜色,默认 RGBA (0,0,0,0.5)
@property (nonatomic, strong) UIColor *colorNotRecoginitonArea;


@end
NS_ASSUME_NONNULL_END

