//
//  ViewController.m
//  JXQRScan
//
//  Created by yituiyun on 2017/11/3.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "ViewController.h"
#import "JXQRScanViewController.h"
#import "CustomScanViewController.h"

@interface ViewController ()<JXQRScanViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    JXQRScanStyle *style = [[JXQRScanStyle alloc]init];
    style.isNeedShowRetangle = NO;
    style.retanglePadding = 120;
    style.centerUpOffset = 104;
    style.colorRetangleLine = [UIColor redColor];
    style.colorAngle = [UIColor yellowColor];
    style.angleH = 20;
    style.angleW = 40;
    style.angleLineW = 4;
    style.anmiationStyle = JXQRScanAnimationStyleNet;
//    style.colorNotRecoginitonArea = [UIColor greenColor];
    
    
//    CustomScanViewController *costomVc = [[CustomScanViewController alloc]init];
//    costomVc.delegate = self;
//    costomVc.style = style;
//    [self.navigationController pushViewController:costomVc animated:YES];
////
    
    JXQRScanViewController *vc = [[JXQRScanViewController alloc]init];
    vc.delegate = self;
    vc.style = style;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)QRScanViewController:(JXQRScanViewController *)vc results:(NSArray<NSString *> *)results{
    
    NSLog(@"results == %@",results);
}

@end
