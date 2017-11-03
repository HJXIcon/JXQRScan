//
//  JXQRScanView.m
//  text
//
//  Created by yituiyun on 2017/11/2.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "JXQRScanView.h"
#import "JXQRScanLineAnimation.h"
#import "JXQRScanNetAnimation.h"
#import "JXQRScanStyle.h"

@interface JXQRScanView ()
//扫码区域
@property (nonatomic, assign) CGRect scanRetangleRect;
@property (nonatomic, strong) JXQRScanLineAnimation *lineAnimation;
@property (nonatomic, strong) JXQRScanNetAnimation *netAnimation;

@end

@implementation JXQRScanView

- (JXQRScanNetAnimation *)netAnimation{
    if (_netAnimation == nil) {
        _netAnimation = [[JXQRScanNetAnimation alloc]init];
    }
    return _netAnimation;
}

- (JXQRScanLineAnimation *)lineAnimation{
    if (_lineAnimation == nil) {
        _lineAnimation = [[JXQRScanLineAnimation alloc]init];
    }
    return _lineAnimation;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [self drawScanRect];
}

- (void)drawScanRect{
    
    if (_viewStyle == nil) {
        _viewStyle = [[JXQRScanStyle alloc]init];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat retangleW = CGRectGetWidth(self.bounds) - 2 * _viewStyle.retanglePadding;
    CGFloat retangleH = retangleW;
    CGFloat retangleMinY = (CGRectGetHeight(self.bounds) - retangleH - _viewStyle.centerUpOffset * 2) * 0.5;
    CGSize retangleSize = CGSizeMake(retangleW, retangleH);
    CGRect retangleRect = CGRectMake(_viewStyle.retanglePadding, retangleMinY, retangleW, retangleH);
    CGFloat retangleMaxX = CGRectGetMaxX(retangleRect);
    CGFloat retangleMaxY = CGRectGetMaxY(retangleRect);
    self.scanRetangleRect = retangleRect;
    
    // 1.非扫码区域半透明
    {
        //设置非识别区域颜色
        
        const CGFloat *components = CGColorGetComponents(_viewStyle.colorNotRecoginitonArea.CGColor);
        
        
        CGFloat red_notRecoginitonArea = components[0];
        CGFloat green_notRecoginitonArea = components[1];
        CGFloat blue_notRecoginitonArea = components[2];
        CGFloat alpa_notRecoginitonArea = components[3];
        
        
        CGContextSetRGBFillColor(context, red_notRecoginitonArea, green_notRecoginitonArea,
                                 blue_notRecoginitonArea, alpa_notRecoginitonArea);
        
        //填充矩形
        
        
        //扫码区域上面填充
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, retangleMinY);
        CGContextFillRect(context, rect);
        
        
        //扫码区域左边填充
        rect = CGRectMake(0, retangleMinY, _viewStyle.retanglePadding,retangleSize.height);
        CGContextFillRect(context, rect);
        
        //扫码区域右边填充
        rect = CGRectMake(retangleMaxX, retangleMinY, _viewStyle.retanglePadding,retangleSize.height);
        CGContextFillRect(context, rect);
        
        //扫码区域下面填充
        rect = CGRectMake(0, retangleMaxY, self.frame.size.width,self.frame.size.height - retangleMaxY);
        CGContextFillRect(context, rect);
        //执行绘画
        CGContextStrokePath(context);
    }
    
    
    // 2.画中间正方形
    if (_viewStyle.isNeedShowRetangle) {
        //中间画矩形(正方形)
        CGContextSetStrokeColorWithColor(context, _viewStyle.colorRetangleLine.CGColor);
        CGContextSetLineWidth(context, 1);
        
        CGContextAddRect(context, CGRectMake(CGRectGetMinX(retangleRect), retangleMinY, retangleSize.width, retangleSize.height));
        
        CGContextStrokePath(context);
    }
    
    
    
    // 3.画矩形框4格外围相框角
    CGContextSetStrokeColorWithColor(context, _viewStyle.colorAngle.CGColor);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    CGContextSetLineWidth(context, _viewStyle.angleLineW);
    
    
    //4个角的 线的宽度
    CGFloat linewidthAngle = _viewStyle.angleLineW;
    
    //相框角的宽度和高度
    CGFloat wAngle = _viewStyle.angleW;
    CGFloat hAngle = _viewStyle.angleH;
    
    CGFloat diffAngle = 0.0f;
    //
    CGFloat leftX = CGRectGetMinX(retangleRect) - diffAngle;
    CGFloat topY = retangleMinY - diffAngle;
    CGFloat rightX = retangleMaxX + diffAngle;
    CGFloat bottomY = retangleMaxY + diffAngle;
    
    
    //左上角水平线
    CGContextMoveToPoint(context, leftX-linewidthAngle/2, topY);
    CGContextAddLineToPoint(context, leftX + wAngle, topY);
    
    //左上角垂直线
    CGContextMoveToPoint(context, leftX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, topY+hAngle);
    
    
    //左下角水平线
    CGContextMoveToPoint(context, leftX-linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(context, leftX + wAngle, bottomY);
    
    //左下角垂直线
    CGContextMoveToPoint(context, leftX, bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, bottomY - hAngle);
    
    
    //右上角水平线
    CGContextMoveToPoint(context, rightX+linewidthAngle/2, topY);
    CGContextAddLineToPoint(context, rightX - wAngle, topY);
    
    //右上角垂直线
    CGContextMoveToPoint(context, rightX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(context, rightX, topY + hAngle);
    
    
    //右下角水平线
    CGContextMoveToPoint(context, rightX+linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(context, rightX - wAngle, bottomY);
    
    //右下角垂直线
    CGContextMoveToPoint(context, rightX, bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(context, rightX, bottomY - hAngle);
    
    CGContextStrokePath(context);
    
}


- (void)beginScanAnimation{
    
    switch (_viewStyle.anmiationStyle) {
        case JXQRScanAnimationStyleLine:
        {
             [self.lineAnimation startAnimatingWithRect:self.scanRetangleRect InView:self Image:_viewStyle.animationImage];
        }
            break;
            
        case JXQRScanAnimationStyleNet:
        {
            [self.netAnimation startAnimatingWithRect:self.scanRetangleRect InView:self Image:_viewStyle.animationImage];
        }
            break;
            
        case JXQRScanAnimationStyleNone:
        {
            break;
        }
            break;
            
        default:
            break;
    }
   
}


- (void)_stopScanAnimation{
    
    [self.lineAnimation stopAnimating];
}

#pragma mark - Public Method
- (void)startScanAnimation{
    [self beginScanAnimation];
}

- (void)stopScanAnimation{
    [self _stopScanAnimation];
}


/**
 获取兴趣点范围
 */
- (CGRect)getScanInsteretRect{
    return self.scanRetangleRect;
}
@end
