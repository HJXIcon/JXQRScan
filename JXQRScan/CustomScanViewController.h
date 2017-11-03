//
//  CustomScanViewController.h
//  JXQRScan
//
//  Created by yituiyun on 2017/11/3.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "JXQRScanViewController.h"

@interface CustomScanViewController : JXQRScanViewController

/**
 @brief  扫码区域上方提示文字
 */
@property (nonatomic, strong) UILabel *topTitle;


#pragma mark - 底部几个功能：开启闪光灯、相册、我的二维码
//底部显示的功能项
@property (nonatomic, strong) UIView *bottomItemsView;
//相册
@property (nonatomic, strong) UIButton *btnPhoto;
//闪光灯
@property (nonatomic, strong) UIButton *btnFlash;
//我的二维码
@property (nonatomic, strong) UIButton *btnMyQR;

@end
