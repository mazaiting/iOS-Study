//
//  ViewController.m
//  02二维码扫描
//
//  Created by mazaiting on 18/1/22.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>
// 1. 输入设备（用来获取外界信息）摄像头，麦克风，键盘
@property (nonatomic, strong) AVCaptureDeviceInput *input;
// 2. 输出设备（将收集到的信息，做解析，来获取收到的内容）
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
// 3. 回话session（用来连接输入和输出设备）
@property (nonatomic, strong) AVCaptureSession *session;
// 4. 特殊的layer(展示设备所采集的信息)
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layer;
@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 1. 输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    // 2. 输出设备
    self.output = [AVCaptureMetadataOutput new];
    // 3. 回话session
    self.session = [AVCaptureSession new];
    // 回话扫描展示的大小
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // 回话跟输入输出设备关联
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    // 指定输出设备的代理， 用来接收返回的数据
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 设置元数据类型 二维码
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // 4. 特殊的layer
    self.layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.layer];
    
    // 5. 启动会话
    [self.session startRunning];
}

#pragma mark 代理方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // 1. 停止回话
    [self.session stopRunning];
    // 2. 删除layer
    [self.layer removeFromSuperlayer];
    // 3. 遍历获取内容
    for (AVMetadataMachineReadableCodeObject *obj in metadataObjects) {
        NSLog(@"obj: %@", obj.stringValue);
    }
}

@end




















