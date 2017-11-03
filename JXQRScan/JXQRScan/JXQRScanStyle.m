//
//  JXQRScanViewStyle.m
//  text
//
//  Created by yituiyun on 2017/11/2.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "JXQRScanStyle.h"

@implementation JXQRScanStyle

- (instancetype)init{
    if (self = [super init]) {
        _isNeedShowRetangle = YES;
        _colorNotRecoginitonArea = [UIColor colorWithRed:0. green:.0 blue:.0 alpha:.5];
        _retanglePadding = 60;
        _colorRetangleLine = [UIColor whiteColor];
        _colorAngle = [UIColor colorWithRed:0. green:167./255. blue:231./255. alpha:1.0];
        _angleW = 20;
        _angleH = 20;
        _angleLineW = 6;
        _centerUpOffset = 44;
        
        _isDrawQRCodeRect = YES;
        _drawQRCodeRectWidth = 2.0;
        _colorDrawQRCodeRect = [UIColor redColor];

        _anmiationStyle = JXQRScanAnimationStyleLine;
        _animationImage = [UIImage imageNamed:@"JXQRScan.bundle/qrcode_scan_light_green@2x"];

    
    }
    return self;
}


- (void)setAnmiationStyle:(JXQRScanAnimationStyle)anmiationStyle{
    _anmiationStyle = anmiationStyle;
    if (anmiationStyle == JXQRScanAnimationStyleNet) {
        _animationImage = [UIImage imageNamed:@"JXQRScan.bundle/qrcode_scan_full_net"];
    }
}


- (void)setColorNotRecoginitonArea:(UIColor *)colorNotRecoginitonArea{
    long num = CGColorGetNumberOfComponents([UIColor redColor].CGColor);
    NSAssert(num == 4, @"'colorNotRecoginitonArea' must be create by [UIColor colorWithRed: green: blue: alpha:]");
    _colorNotRecoginitonArea = colorNotRecoginitonArea;
}


@end
