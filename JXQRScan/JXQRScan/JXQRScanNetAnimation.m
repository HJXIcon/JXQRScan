//
//  JXQRScanNetAnimation.m
//  text
//
//  Created by yituiyun on 2017/11/2.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "JXQRScanNetAnimation.h"

@interface JXQRScanNetAnimation()
{
    BOOL isAnimationing;
}

@property (nonatomic,assign) CGRect animationRect;
@property (nonatomic,strong) UIImageView *scanImageView;

@end

@implementation JXQRScanNetAnimation
- (UIImageView *)scanImageView{
    if (_scanImageView == nil) {
        _scanImageView = [[UIImageView alloc] init];
    }
    return _scanImageView;
}


- (instancetype)init{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        [self addSubview:self.scanImageView];
    }
    return self;
}


- (void)stepAnimation
{
    if (!isAnimationing) {
        return;
    }
    
    self.frame = _animationRect;
    
    CGFloat scanNetImageViewW = self.frame.size.width;
    CGFloat scanNetImageH = self.frame.size.height;
    
    __weak __typeof(self) weakSelf = self;
    self.alpha = 0.5;
    _scanImageView.frame = CGRectMake(0, -scanNetImageH, scanNetImageViewW, scanNetImageH);
    [UIView animateWithDuration:1.4 animations:^{
        weakSelf.alpha = 1.0;
        
        _scanImageView.frame = CGRectMake(0, scanNetImageViewW-scanNetImageH, scanNetImageViewW, scanNetImageH);
        
    } completion:^(BOOL finished)
     {
         [weakSelf performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
     }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
}


- (void)startAnimatingWithRect:(CGRect)animationRect InView:(UIView *)parentView Image:(UIImage*)image
{
    [self.scanImageView setImage:image];
    
    self.animationRect = animationRect;
    
    [parentView addSubview:self];
    
    self.hidden = NO;
    
    isAnimationing = YES;
    
    [self stepAnimation];
}


- (void)dealloc
{
    [self stopAnimating];
}

- (void)stopAnimating
{
    self.hidden = YES;
    isAnimationing = NO;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}


@end