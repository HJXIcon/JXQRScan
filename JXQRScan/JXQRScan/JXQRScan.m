//
//  JXQRScan.m
//  text
//
//  Created by yituiyun on 2017/11/2.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "JXQRScan.h"
#import <AVFoundation/AVFoundation.h>
typedef void(^ResultBlock)(NSArray<NSString *> *resultStrs);

@interface JXQRScan ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *prelayer;
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
@property(nonatomic,strong)  AVCaptureStillImageOutput *stillImageOutput;//拍照
#pragma clang diagnostic pop
@property (nonatomic, copy) ResultBlock resultBlock;

@property (nonatomic, strong) NSMutableArray *deleteTempLayers;

/**
 @brief  视频预览显示视图
 */
@property (nonatomic,weak) UIView *videoPreView;

@end

@implementation JXQRScan

#pragma mark - lazy load
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
//写在这个中间的代码,都不会被编译器提示-Wdeprecated-declarations类型的警告
- (AVCaptureStillImageOutput *)stillImageOutput{
    if (_stillImageOutput == nil) {
        
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        AVVideoCodecJPEG, AVVideoCodecKey,
                                        nil];
        [_stillImageOutput setOutputSettings:outputSettings];
    }
    return _stillImageOutput;
}
#pragma clang diagnostic pop


-(NSMutableArray *)deleteTempLayers
{
    if (_deleteTempLayers == nil) {
        _deleteTempLayers = [NSMutableArray array];
    }
    return _deleteTempLayers;
}

// 懒加载输入
-(AVCaptureDeviceInput *)input
{
    if (_input == nil) {
        // 获取摄像头设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // 设置为输入设备
        _input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
    }
    return _input;
}

// 懒加载输出
-(AVCaptureMetadataOutput *)output
{
    if (_output == nil) {
        // 设置元数据输出
        _output = [[AVCaptureMetadataOutput alloc] init];
        // 设置输出处理者
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
    return _output;
}

// 懒加载session
-(AVCaptureSession *)session
{
    if (_session == nil) {
        // 创建会话, 并设置输入输出
        _session = [[AVCaptureSession alloc] init];
        
    }
    return _session;
}

// 懒加载预览层
-(AVCaptureVideoPreviewLayer *)prelayer
{
    if (_prelayer == nil) {
        _prelayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    }
    return _prelayer;
}



- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections
{
    for ( AVCaptureConnection *connection in connections ) {
        for ( AVCaptureInputPort *port in [connection inputPorts] ) {
            if ( [[port mediaType] isEqual:mediaType] ) {
                return connection;
            }
        }
    }
    return nil;
}

#pragma mark - setter
- (void)setTorch:(BOOL)torch{
    _torch = torch;
    [self.input.device lockForConfiguration:nil];
    self.input.device.torchMode = torch ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
    [self.input.device unlockForConfiguration];
}


#pragma mark - Public Method
// 自动根据闪关灯状态去改变
- (void)openOrCloseFlash{
    AVCaptureTorchMode torch = self.input.device.torchMode;
    
    switch (self.input.device.torchMode) {
        case AVCaptureTorchModeAuto:
            break;
        case AVCaptureTorchModeOff:
            torch = AVCaptureTorchModeOn;
            break;
        case AVCaptureTorchModeOn:
            torch = AVCaptureTorchModeOff;
            break;
        default:
            break;
    }
    
    [self.input.device lockForConfiguration:nil];
    self.input.device.torchMode = torch;
    [self.input.device unlockForConfiguration];
}

/**
 @brief 拉近拉远镜头
 @param scale 系数
 */
- (void)setVideoScale:(CGFloat)scale
{
    [_input.device lockForConfiguration:nil];
    
    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
    
    CGFloat zoom = scale / videoConnection.videoScaleAndCropFactor;
    
    videoConnection.videoScaleAndCropFactor = scale;
    
    [_input.device unlockForConfiguration];
    
    CGAffineTransform transform = _videoPreView.transform;
    
    [UIView animateWithDuration:.25 animations:^{
        _videoPreView.transform = CGAffineTransformScale(transform, zoom, zoom);
    }];
}

// 获取摄像机最大拉远镜头
- (CGFloat)getVideoMaxScale
{
    [self.input.device lockForConfiguration:nil];
    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[self.stillImageOutput connections]];
    CGFloat maxScale = videoConnection.videoMaxScaleAndCropFactor;
    [self.input.device unlockForConfiguration];
    
    return maxScale;
}

/// 开始扫描, 并添加预览层到指定视图, 扫描结果通过block返回
- (void)beginScanInView:(UIView *)view result:(void(^)(NSArray<NSString *> *resultStrs))resultBlock
{
    self.resultBlock = resultBlock;
    _videoPreView = view;
    
    if ([self.session canAddOutput:self.stillImageOutput])
    {
        [self.session addOutput:self.stillImageOutput];
    }
    
    // 4. 创建并设置会话
    if ([self.session canAddInput:self.input] && [self.session canAddOutput:self.output]) {
        [self.session addInput:self.input];
        [self.session addOutput:self.output];
        NSLog(@"test");
        // 设置元数据处理类型(注意, 一定要将设置元数据处理类型的代码添加到  会话添加输出之后)
        [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    }
//    else
//    {
//        return;
//    }
    
    
    // 添加预览图层
    if (![view.layer.sublayers containsObject:self.prelayer])
    {
        self.prelayer.frame = _videoPreView.bounds;
        [_videoPreView.layer insertSublayer:self.prelayer atIndex:0];
    }
    
    // 5. 启动会话
    [self.session startRunning];
    
}

- (void)stopScan
{
    if (self.input && self.session.isRunning) {
        [self.session stopRunning];
    }
    
}

- (void)setInsteretRect:(CGRect)originRect
{
    
    // 设置兴趣点
    // 注意: 兴趣点的坐标是横屏状态(0, 0 代表竖屏右上角, 1,1 代表竖屏左下角)
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    CGFloat x = originRect.origin.x / screenBounds.size.width;
    CGFloat y = originRect.origin.y / screenBounds.size.height;
    CGFloat width = originRect.size.width / screenBounds.size.width;
    CGFloat height = originRect.size.height / screenBounds.size.height;
    
    self.output.rectOfInterest = CGRectMake(y, x, height, width);
}


// 添加二维码边框图层
- (void)addShapLayers:(AVMetadataMachineReadableCodeObject *)transformObj
{
    // 绘制边框
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = _colorDrawQRCodeRect.CGColor;
    layer.lineWidth = _drawQRCodeRectWidth;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    // 创建一个贝塞尔曲线
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    
    int index = 0;
    for (NSDictionary *pointDic in transformObj.corners)
    {
        CFDictionaryRef dic = (__bridge CFDictionaryRef)(pointDic);
        CGPoint point = CGPointZero;
        CGPointMakeWithDictionaryRepresentation(dic, &point);
        if (index == 0) {
            [path moveToPoint:point];
        }else
        {
            [path addLineToPoint:point];
        }
        index ++;
        
    }
    [path closePath];
    layer.path = path.CGPath;
    [self.prelayer addSublayer:layer];
    [self.deleteTempLayers addObject:layer];
}

// 移除二维码边框图层
- (void)removeShapLayers
{
    // 移除图层
    for (CALayer *layer in self.deleteTempLayers) {
        [layer removeFromSuperlayer];
    }
    
    [self.deleteTempLayers removeAllObjects];
    
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (self.isDrawQRCodeRect) {
        [self removeShapLayers];
    }
    NSMutableArray *resultStrs = [NSMutableArray array];
    for (AVMetadataMachineReadableCodeObject *obj in metadataObjects)
    {
        [resultStrs addObject:obj.stringValue];
        
        if (self.isDrawQRCodeRect) {
            // obj 中的四个角, 是没有转换后的角, 需要我们使用预览图层转换
            AVMetadataMachineReadableCodeObject *tempObj = (AVMetadataMachineReadableCodeObject *)[self.prelayer transformedMetadataObjectForMetadataObject:obj];
            [self addShapLayers:tempObj];
            
        }
        
    }
    
    if (resultStrs.count) {
        self.resultBlock(resultStrs);
    }
    
    
}



/**
 识别QR二维码图片,ios8.0以上支持
 
 @param QRImage 图片
 @param success 返回识别结果
 */
+ (void)recognizeQRImage:(UIImage *)QRImage success:(void(^)(NSArray <NSString *> *array))success{
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 8.0 )
    {
        NSAssert(NO, @"只支持ios8.0之后系统");
        return;
    }
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:QRImage.CGImage]];
    NSMutableArray <NSString *> *mutableArray = [[NSMutableArray alloc]initWithCapacity:1];
    for (int index = 0; index < [features count]; index ++)
    {
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        NSString *scannedResult = feature.messageString;
        [mutableArray addObject:scannedResult];
    }
    
    if (success && mutableArray.count) {
        success(mutableArray);
    }
}

@end
