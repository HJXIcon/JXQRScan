//
//  JXCreateQRTool.m
//  text
//
//  Created by yituiyun on 2017/11/2.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "JXCreateQRTool.h"


@implementation JXCreateQRTool

#pragma mark - 生成二维码，背景色及二维码颜色设置
+ (UIImage *)createQRWithString:(NSString *)text QRSize:(CGSize)size{
    
    NSData *stringData = [text dataUsingEncoding: NSUTF8StringEncoding];
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
    
}

//引用自:http://www.jianshu.com/p/e8f7a257b612
+ (UIImage *)createQRWithString:(NSString *)text QRSize:(CGSize)size QRColor:(UIColor *)qrColor bkColor:(UIColor *)bkColor
{
    
    NSData *stringData = [text dataUsingEncoding: NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:qrColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:bkColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

+ (UIImage *)createBarCodeWithString:(NSString *)text QRSize:(CGSize)size
{
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:false];
    
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *barcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = size.width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = size.height / barcodeImage.extent.size.height;
    
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
    
}


// 在原来的二维码的图片上画一个图片
+ (UIImage *)addImageToQR:(UIImage *)QRImage AddImage:(UIImage *)addImage{
    
    //  在原来的二维码的图片上画一个头像
    //  开启图片上下文
    UIGraphicsBeginImageContext(QRImage.size);
    //  绘制二维码图片
    [QRImage drawInRect:CGRectMake(0, 0, QRImage.size.width, QRImage.size.height)];
    
    //  绘制头像
    UIImage *headImage = addImage;
    CGFloat headW = QRImage.size.width * 0.2;
    CGFloat headH = QRImage.size.height * 0.2;
    CGFloat headX = (QRImage.size.width - headW) * 0.5;
    CGFloat headY = (QRImage.size.height - headH) * 0.5;
    [headImage drawInRect:CGRectMake(headX, headY, headW, headH)];
    //  从图片上下文中取出图片
    UIImage *image  = UIGraphicsGetImageFromCurrentImageContext();
    
    //  关闭图片上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end
