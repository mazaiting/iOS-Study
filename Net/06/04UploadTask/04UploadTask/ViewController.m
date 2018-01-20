//
//  ViewController.m
//  04UploadTask
//
//  Created by mazaiting on 18/1/9.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLSessionTaskDelegate>
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation ViewController

// 懒加载
- (NSURLSession *)session {
    if (_session == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:0];
    }
    return _session;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self uploadTask];
    [self uploadTask1];
}

// 上传文件，监听进度
- (void)uploadTask1 {
    
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/uploads/123.png"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"put";
    [request setValue:[self getAuth:@"admin" pwd:@"1"] forHTTPHeaderField:@"Authorization"];
    // 本地文件
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"head1.png" withExtension:nil];
    
    [[self.session uploadTaskWithRequest:request fromFile:fileUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"---%@", str);
    }] resume];
}

#pragma mark - 上传进度代理方法
// 上传进度
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    // 进度 = 已发送的 / 一共需要发送的
    float process = totalBytesSent * 1.0 / totalBytesExpectedToSend;
    NSLog(@"%f", process);
}

// 上传完成
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"上传完成");
}


// 上传文件
- (void)uploadTask {
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/uploads/123.png"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"put";
    [request setValue:[self getAuth:@"admin" pwd:@"1"] forHTTPHeaderField:@"Authorization"];
//    [request setValue:@"Basic YWRtaW46MQ==" forHTTPHeaderField:@"Authorization"];
    // 本地文件
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"head1.png" withExtension:nil];
    [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromFile:fileUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", str);
    }] resume];
}

// 获取授权的字符串
- (NSString *)getAuth:(NSString *)name pwd:(NSString *)pwd {
    // 拼字符串 admin:1
    NSString *tmpStr = [NSString stringWithFormat:@"%@:%@",name,pwd];
    // base64编码
    tmpStr = [self base64Encode:tmpStr];
    return [NSString stringWithFormat:@"Basic %@", tmpStr];
}

// base64编码
- (NSString *)base64Encode:(NSString *)str {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

@end
