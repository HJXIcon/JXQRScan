//
//  JXQRScanView.h
//  text
//
//  Created by yituiyun on 2017/11/2.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JXQRScanStyle;
@interface JXQRScanView : UIView

@property (nonatomic, strong) JXQRScanStyle *viewStyle;

- (void)startScanAnimation;
- (void)stopScanAnimation;

/**
 获取兴趣点范围
 */
- (CGRect)getScanInsteretRect;

@end
