//
//  JXQRScanViewController.m
//  text
//
//  Created by yituiyun on 2017/11/2.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "JXQRScanViewController.h"


@interface JXQRScanViewController ()
@property (nonatomic, strong) JXQRScanView *qrScanView;
@property (nonatomic, strong) JXQRScan *QRScan;
@property (nonatomic, assign) BOOL isScale;
@end

@implementation JXQRScanViewController
#pragma mark - lazy load
- (JXQRScan *)QRScan{
    if (_QRScan == nil) {
        _QRScan = [[JXQRScan alloc] init];
        _QRScan.isDrawQRCodeRect = _style.isDrawQRCodeRect;
        _QRScan.colorDrawQRCodeRect = _style.colorDrawQRCodeRect;
        _QRScan.drawQRCodeRectWidth = _style.drawQRCodeRectWidth;
        
    }
    return _QRScan;
}
- (JXQRScanView *)qrScanView{
    if (_qrScanView == nil) {
        
        _qrScanView = [[JXQRScanView alloc]init];
        _qrScanView.viewStyle = _style;
    }
    return _qrScanView;
}

#pragma mark - setter
- (void)setDoubleTapScaleValue:(CGFloat)doubleTapScaleValue{
    NSAssert(doubleTapScaleValue > 1, @"'doubleTapScaleValue'必须大于1");
    
    _doubleTapScaleValue = doubleTapScaleValue;
}

- (void)setDoubleTapEnabled:(BOOL)doubleTapEnabled{
    _doubleTapEnabled = doubleTapEnabled;
    if (doubleTapEnabled) {
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction)];
        doubleTapGesture.numberOfTapsRequired = 2;
        doubleTapGesture.numberOfTouchesRequired = 1;
        [self.view addGestureRecognizer:doubleTapGesture];
    }
}

#pragma mark - cycle life
- (instancetype)init{
    self.style = [[JXQRScanStyle alloc]init];
    self.doubleTapScaleValue = 3;
    self.doubleTapEnabled = YES;
    return [super init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (![self.view.subviews containsObject:self.qrScanView]) {
        self.qrScanView.frame = self.view.bounds;
        [self.view addSubview:self.qrScanView];
    }
    
    [JXQRCheckUp requestCameraCheckUpWithResult:^(BOOL granted) {
        if (granted) {
            
            //不延时，可能会导致界面黑屏并卡住一会
            [self performSelector:@selector(startScan) withObject:nil afterDelay:0.3];
            
        }else{
            NSAssert(NO, @"请到设置隐私中开启本程序相机权限");
        }
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self stopScan];
    
}


#pragma mark - doubleTapAction
- (void)doubleTapAction{
    
    [self.QRScan setVideoScale:_isScale == NO ? _doubleTapScaleValue : 1];
    _isScale = !_isScale;
}


#pragma mark - Public Method
// 开始
- (void)startScan{
    [self.qrScanView startScanAnimation];
    __weak typeof(self) weakSelf = self;
    [self.QRScan setInsteretRect:[_qrScanView getScanInsteretRect]];
    [self.QRScan beginScanInView:self.view result:^(NSArray<NSString *> *resultStrs) {
        
        [weakSelf stopScan];
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(QRScanViewController:results:)]) {
            [weakSelf.delegate QRScanViewController:weakSelf results:resultStrs];
        }
        
    }];
}
- (void)stopScan{
    
    [self.qrScanView stopScanAnimation];
    [self.QRScan stopScan];
}

#pragma mark ** 开关闪光灯
- (void)openOrCloseFlash{
    
    [self.QRScan openOrCloseFlash];
}

#pragma mark ** 打开相册并识别图片
- (void)openPhotoAndScanImage:(BOOL)allowsEditing{
    
    if (![JXQRCheckUp photoCheckUp]) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请到设置隐私中开启本程序照片权限" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    //部分机型有问题
    picker.allowsEditing = allowsEditing;
    
    [self presentViewController:picker animated:YES completion:nil];
}


//当选择一张图片后进入这里
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    __weak __typeof(self) weakSelf = self;
    
     NSAssert([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0, @"只支持ios8.0之后系统");
    
    [JXQRScan recognizeQRImage:image success:^(NSArray<NSString *> *array) {
        [weakSelf stopScan];
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(QRScanViewController:results:)]) {
            [weakSelf.delegate QRScanViewController:weakSelf results:array];
        }
        
    }];
    
    
}


@end
