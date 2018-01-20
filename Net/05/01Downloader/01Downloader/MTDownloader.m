//
//  MTDownloader.m
//  01Downloader
//
//  Created by mazaiting on 18/1/8.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "MTDownloader.h"
// 分类
@interface MTDownloader () <NSURLConnectionDataDelegate>
// 记录文件的总长度,因为在获取下载进度的时候需要文件总长度，所以定义为属性
@property (nonatomic, assign) long long expectedContentLength;
// 记录当前文件的长度
@property (nonatomic, assign) long long currentFileSize;
// NSOutputStream用来保存每次下载的二进制数据
@property (nonatomic, strong) NSOutputStream *outputStream;
@end

@implementation MTDownloader

- (void)download:(NSString *)netUrl {
    // 创建url
    NSURL *url = [NSURL URLWithString:netUrl];
    // 创建下载请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 设置代理, 实现NSURLConnectionDataDelegate协议
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark- 代理方法
// 接收到响应头
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"接收到响应 %@", response);
    // 获取到文件的总长度
    self.expectedContentLength = response.expectedContentLength;
    // 保存文件的路径
    NSString *filePath = @"/Users/mazaiting/Desktop/1.zip";
    // 接收到响应头的时候初始化outputStream
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
    // 打开流
    [self.outputStream open];
}

// 接收到数据--一点点接收
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // 将每次接收到的字节长度与已有的文件长度相加
    self.currentFileSize += data.length;
    // 当前已下载的文件长度 * 1.0 / 文件的总长度 = 当前的进度
    float process = self.currentFileSize * 1.0 / self.expectedContentLength;
    NSLog(@"接收数据: %f", process);
    // 保存数据
    [self saveData:data];
}

// 下载完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"下载完成");
    // 下载完成的时候，关闭流
    [self.outputStream close];}

// 下载出错
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"下载出错");
    // 判断流是否为空，下载出错的时候，关闭流
    if (self.outputStream) {
        [self.outputStream close];
    }
}

// NSOutputStream保存数据
// data 每次下载的二进制文件
- (void)saveData:(NSData *)data {
    // 写数据
    [self.outputStream write:data.bytes maxLength:data.length];
}

// NSFileHandle保存数据
// data 每次下载的二进制数据
- (void)saveData1:(NSData *)data {
    // 保存文件的路径
    NSString *filePath = @"/Users/mazaiting/Desktop/1.zip";
    // 根据路径获取NSFileHandle, 它不会自动创建文件，而是第0个字节添加数据
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    // 如果fileHandle存在，则让fileHandle的offset偏移量指向文件的末尾，进行数据的添加
    // 如果fileHandle不存在，则创建文件
    if (fileHandle) {
        // fileHandle存在
        // 将文件指针指向文件的末尾
        [fileHandle seekToEndOfFile];
        // 写数据
        [fileHandle writeData:data];
        // 关闭文件
        [fileHandle closeFile];
    } else {
        // fileHandle不存在
        [data writeToFile:filePath atomically:YES];
    }
}

@end
