//
//  MTDownloader.m
//  01Downloader
//
//  Created by mazaiting on 18/1/8.
//  Copyright © 2018年 mazaiting. All rights reserved.
//
// 断点续传思路
// 1. 首先发送一个head请求，获取到服务器文件的大小和名称
// 2. 判断本地文件是否存在
//      1). 不存在，从0开始下载
//      2). 存在
//          a. 本地文件大小 == 服务器文件大小  不需要下载
//          b. 本地文件大小 < 服务器文件大小   从当前位置下载
//          c. 本地文件打下 > 服务器文件大小   删除文件，从0下载
#import "MTDownloader.h"
// 分类
@interface MTDownloader () <NSURLConnectionDataDelegate>
// 记录文件的总长度,因为在获取下载进度的时候需要文件总长度，所以定义为属性
@property (nonatomic, assign) long long expectedContentLength;
// 记录当前文件的长度
@property (nonatomic, assign) long long currentFileSize;
// NSOutputStream用来保存每次下载的二进制数据
@property (nonatomic, strong) NSOutputStream *outputStream;
// 下载时创建的NSURLConnection，可用于取消下载
@property (nonatomic, strong) NSURLConnection *urlConnection;
// 文件的存储路径
@property (nonatomic, strong) NSString *filePath;
// 下载成功后的回调
@property (nonatomic, copy) void (^successBlock)(NSString *path);
// 下载进度回调
@property (nonatomic, copy) void (^processBlock)(float process);
// 下载异常的回调
@property (nonatomic, copy) void (^errorBlock)(NSError *error);
// 下载链接
@property (nonatomic, copy) NSString *urlString;
@end

@implementation MTDownloader
// 下载
+ (instancetype)download:(NSString *)netUrl successBlock:(void (^)(NSString *))successBlock processBlock:(void (^)(float))processBlock errorBlock:(void (^)(NSError *))errorBlock {
    MTDownloader *downloader = [MTDownloader new];
    downloader.successBlock = successBlock;
    downloader.processBlock = processBlock;
    downloader.errorBlock = errorBlock;
    downloader.urlString = netUrl;
    return downloader;
}

- (void)main {
    @autoreleasepool {
        // 创建url
        NSURL *url = [NSURL URLWithString:self.urlString];
        // 获取服务器文件信息, 获取当前文件长度
        [self getServerFileInfo:url];
        // 获取本地文件信息，并且和服务器做比较
        self.currentFileSize = [self getLocalFileInfo];
        // 判断当前文件大小是否是-1，如果是-1，说明文件已经下载完成
        if (self.currentFileSize == -1) {
            //        NSLog(@"文件已下载完成，请不要重复下载!!!");
            // 如果下载回调不为空
            if (self.successBlock) {
                // 分发消息到主线程，让主线程来处理
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.successBlock(self.filePath);
                });
            }
            return;
        }
        
        // 从指定位置处下载文件
        [self downloadFile: url];
    }
}

// 从指定位置处下载文件
- (void)downloadFile:(NSURL *)url {
    // 创建一个新的线程，并添加到队列中
    [[NSOperationQueue new] addOperationWithBlock:^{
        // 创建一个请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        // 请求头
        // Range:bytes=x-y 从x个字节下载到y个字节
        // Range:bytes=x-  从x个字节下载到最后
        // Range:bytes=-y  从开始下载到y个字节
        [request setValue:[NSString stringWithFormat:@"bytes=%lld-", self.currentFileSize] forHTTPHeaderField:@"Range"];
        
        // 设置代理, 实现NSURLConnectionDataDelegate协议
        self.urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        // 开启消息循环
        [[NSRunLoop currentRunLoop] run];
    }];
    
}

// 检测本地文件大小
- (long long)getLocalFileInfo {
    // 文件的长度， 如果文件不存在，则为0
    long long fileSize = 0;
    // 获取文件管理者对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 判断文件是否存在
    if ([fileManager fileExistsAtPath:self.filePath]) {
        // 文件存在
        // 获取本地文件的大小
        NSDictionary *attrs = [fileManager attributesOfItemAtPath:self.filePath error:NULL];
        // 赋值
        fileSize = attrs.fileSize;
        // 文件大小等于服务器文件长度
        if (fileSize == self.expectedContentLength) {
            fileSize = -1;
        }
        // 文件大小大于服务器文件长度
        if (fileSize > self.expectedContentLength) {
            fileSize = 0;
            // 删除文件
            [fileManager removeItemAtPath:self.filePath error:NULL];
        }
    }
    return fileSize;
}

// 获取服务器文件信息
// 文件的url
- (void)getServerFileInfo:(NSURL *)url {
    // 创建一个请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置请求方法
    request.HTTPMethod = @"head";
    // 同步请求响应体
    NSURLResponse *response = nil;
    // 发送一个同步请求
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
    
    // 设置文件的总长度，注意:在下载时- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;方法中为当前文件总长度赋值的语句要删除
    self.expectedContentLength = response.expectedContentLength;
    // 设置文件的存储路径, 存储在临时目录下，拼接文件名
    self.filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename];
//    NSLog(@"%@", self.filePath);
}

// 暂停下载
- (void)pause {
    // 取消下载
    [self.urlConnection cancel];
    // 取消自定义操作
    [self cancel];
}

#pragma mark- 代理方法
// 接收到响应头
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    NSLog(@"接收到响应 %@", response);
    // 接收到响应头的时候初始化outputStream
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:YES];
    // 打开流
    [self.outputStream open];
}

// 接收到数据--一点点接收
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // 将每次接收到的字节长度与已有的文件长度相加
    self.currentFileSize += data.length;
    // 当前已下载的文件长度 * 1.0 / 文件的总长度 = 当前的进度
    float process = self.currentFileSize * 1.0 / self.expectedContentLength;
//    NSLog(@"接收数据: %f", process);
    // 保存数据
    [self saveData:data];
    // 判断进度回调是否为空
    if (self.processBlock) {
        // 如果不为空则回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            self.processBlock(process);
        });
    }
}

// 下载完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    NSLog(@"下载完成");
    // 下载完成的时候，关闭流
    [self.outputStream close];
    
    // 如果下载回调不为空
    if (self.successBlock) {
        // 分发消息到主线程，让主线程来处理
        dispatch_async(dispatch_get_main_queue(), ^{
            self.successBlock(self.filePath);
        });
    }
}

// 下载出错
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//    NSLog(@"下载出错");
    // 判断流是否为空，下载出错的时候，关闭流
    if (self.outputStream) {
        [self.outputStream close];
    }
    // 判断异常回调是否为空
    if (self.errorBlock) {
        // 不为空回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            self.errorBlock(error);
        });
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
