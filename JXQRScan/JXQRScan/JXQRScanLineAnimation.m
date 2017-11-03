//
//  JXQRScanLineAnimation.m
//  text
//
//  Created by yituiyun on 2017/11/2.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "JXQRScanLineAnimation.h"
@interface JXQRScanLineAnimation()
@property (nonatomic, assign) BOOL down;
@property (nonatomic, assign) BOOL isAnimationing;
@property (nonatomic,assign) CGRect animationRect;

@end

@implementation JXQRScanLineAnimation

/**
 *  开始扫码线动画
 *
 *  @param animationRect 显示在parentView中得区域
 *  @param parentView    动画显示在UIView
 *  @param image     扫码线的图像
 */
- (void)startAnimatingWithRect:(CGRect)animationRect InView:(UIView*)parentView Image:(UIImage*)image{
    
    if (self.isAnimationing) {
        return;
    }
    
    self.isAnimationing = YES;
    
    self.animationRect = animationRect;
    self.down = YES;
    
    
    CGFloat centery = CGRectGetMinY(animationRect) + CGRectGetHeight(animationRect)/2;
    CGFloat leftx = CGRectGetMinX(animationRect) + 5;
    CGFloat width = CGRectGetWidth(animationRect) - 10;
    
    self.frame = CGRectMake(leftx, centery, width, 10);
    
    self.image = image;
    
    [parentView addSubview:self];
    [parentView bringSubviewToFront:self];
    
    [self startAnimating_UIViewAnimation];
    
    
}

/**
 *  停止动画
 */
- (void)stopAnimating{
    if (self.isAnimationing) {
        self.isAnimationing = NO;
        [self removeFromSuperview];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Private Method

- (void)startAnimating_UIViewAnimation
{
    [self stepAnimation];
}


- (void)stepAnimation
{
    if (!self.isAnimationing) {
        return;
    }
    
    
    CGFloat leftx = _animationRect.origin.x + 5;
    CGFloat width = _animationRect.size.width - 10;
    
    self.frame = CGRectMake(leftx, _animationRect.origin.y + 8, width, 8);
    
    self.alpha = 0.0;
    
    self.hidden = NO;
    
    __weak __typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 1.0;
        
        
    } completion:^(BOOL finished)
     {
         
     }];
    
    [UIView animateWithDuration:3 animations:^{
        CGFloat leftx = _animationRect.origin.x + 5;
        CGFloat width = _animationRect.size.width - 10;
        
        weakSelf.frame = CGRectMake(leftx, _animationRect.origin.y + _animationRect.size.height - 8, width, 4);
        
    } completion:^(BOOL finished)
     {
         self.hidden = YES;
         [weakSelf performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
     }];
}



@end
