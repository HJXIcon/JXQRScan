# JXQRScan
二维码扫描

####支持pod

pod 'JXQRScan', '~> 1.0.0' <br/>

#### 使用继承JXQRScanViewController的控制器

``` 
 JXQRScanStyle *style = [[JXQRScanStyle alloc]init];
//    style.isNeedShowRetangle = NO;
//    style.retanglePadding = 120;
    style.centerUpOffset = 104;
//    style.colorRetangleLine = [UIColor redColor];
//    style.colorAngle = [UIColor yellowColor];
//    style.angleH = 20;
//    style.angleW = 40;
//    style.angleLineW = 4;
//    style.anmiationStyle = JXQRScanAnimationStyleNet;
//    style.colorNotRecoginitonArea = [UIColor greenColor];
    
    
    CustomScanViewController *costomVc = [[CustomScanViewController alloc]init];
    
    costomVc.delegate = self;
    costomVc.style = style;
    [self.navigationController pushViewController:costomVc animated:YES];
```
#### 或者直接使用JXQRScanViewController
```
//    JXQRScanViewController *vc = [[JXQRScanViewController alloc]init];
//    vc.delegate = self;
//    vc.style = style;
//    [self.navigationController pushViewController:vc animated:YES];
```