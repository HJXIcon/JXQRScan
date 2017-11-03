//
//  JXCreateQRTool.h
//  text
//
//  Created by yituiyun on 2017/11/2.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JXCreateQRTool : NSObject
/**
 生成QR二维码
 
 @param text 字符串
 @param size 二维码大小
 @return 返回二维码图像
 */
+ (UIImage *)createQRWithString:(NSString *)text QRSize:(CGSize)size;


/**
 生成QR二维码
 
 @param text 字符串
 @param size 大小
 @param qrColor 二维码前景色
 @param bkColor 二维码背景色
 @return 二维码图像
 */
+ (UIImage *)createQRWithString:(NSString *)text QRSize:(CGSize)size QRColor:(UIColor *)qrColor bkColor:(UIColor *)bkColor;


/**
 生成条形码
 
 @param text 字符串
 @param size 大小
 @return 返回条码图像
 */
+ (UIImage *)createBarCodeWithString:(NSString *)text QRSize:(CGSize)size;


/**
 在原来的二维码的图片上画一个图片
 
 @param QRImage 二维码
 @param addImage 添加图片
 */
+ (UIImage *)addImageToQR:(UIImage *)QRImage AddImage:(UIImage *)addImage;

@end
