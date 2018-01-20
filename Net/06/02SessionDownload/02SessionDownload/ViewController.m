//
//  ViewController.m
//  02SessionDownload
//
//  Created by mazaiting on 18/1/9.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumData;
@end

@implementation ViewController
// 开始下载
- (IBAction)start {
    [self download];
}

// 暂停下载
- (IBAction)pause {
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        // 记录已下载的数据
        self.resumData = resumeData;
        // 把续传数据保存到沙盒中
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"123.tmp"];
        [self.resumData writeToFile:path atomically:YES];
        NSLog(@"%@", path);
        // 将下载任务置为空
        self.downloadTask = nil;
    }];
}

// 继续下载
- (IBAction)resume {
    // 从沙盒中获取续传数据
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"123.tmp"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        self.resumData = [NSData dataWithContentsOfFile:path];
    }
    
    if (self.resumData == nil) {
        return;
    }
    
    // 调用断点下载方法
    self.downloadTask = [self.session downloadTaskWithResumeData:self.resumData];
    [self.downloadTask resume];
    // 将续传数据置为空
    self.resumData = nil;
}


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
    
//    [self download1];
}

// 下载，设置代理，获取进度
- (void)download {
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/HBuilder.zip"];
    self.downloadTask = [self.session downloadTaskWithURL:url];
    // 开始下载
    [self.downloadTask resume];
}

// 写数据
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float process = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
    NSLog(@"%f", process);
}

// 断点下载数据
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"续传");
}

// 下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"%@", [NSThread currentThread]);
    NSLog(@"下载完成 %@", location);
}


// 此方法无法获取到文件的下载进度，只能在结束时做响应
- (void)download1 {
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/HBuilder.zip"];
    [[[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 当前线程， 子线程
        NSLog(@"%@", [NSThread currentThread]);
        // 当前文件位置，临时文件，下载完成后删除临时文件
        NSLog(@"%@",location);
        // 将文件复制到自己想要的位置
        // 存放文件的路径
        NSString *doc = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Builder.zip"];
        // 复制文件
        [[NSFileManager defaultManager] copyItemAtPath:location.path toPath:doc error:NULL];
    }] resume];
}


@end
