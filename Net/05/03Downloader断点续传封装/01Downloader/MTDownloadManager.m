//
//  MTDownloadManager.m
//  02Downloader断点续传
//
//  Created by mazaiting on 18/1/8.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "MTDownloadManager.h"
#import "MTDownloader.h"

@interface MTDownloadManager ()
// 下载操作缓存池
@property (nonatomic, strong) NSMutableDictionary *downloadCache;
@end

@implementation MTDownloadManager
// 单例
+ (instancetype)sharedManager {
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

// 懒加载
- (NSMutableDictionary *)downloadCache {
    if (_downloadCache == nil) {
        _downloadCache = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _downloadCache;
}
// 下载
- (void)download:(NSString *)netUrl successBlock:(void (^)(NSString *))successBlock processBlock:(void (^)(float))processBlock errorBlock:(void (^)(NSError *))errorBlock {
    // 判断缓存池中是否有下载操作
    if (self.downloadCache[netUrl]) {
        NSLog(@"正在拼命下载中...");
        return;
    }
    // 新建下载
    MTDownloader *downloader = [MTDownloader download:netUrl successBlock:^(NSString *path) {
        // 移除下载操作
        [self.downloadCache removeObjectForKey:netUrl];
        if (successBlock) {
            successBlock(path);
        }
    } processBlock:processBlock errorBlock:^(NSError *error) {
        // 移除下载操作
        [self.downloadCache removeObjectForKey:netUrl];
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    [[NSOperationQueue new] addOperation:downloader];
    
    // 添加到缓存池中
    [self.downloadCache setObject:downloader forKey:netUrl];
}
// 暂停
- (void)pause:(NSString *)netUrl {
    MTDownloader *downloader = self.downloadCache[netUrl];
    // 判断是否为空，如果不为空，则暂停；如果为空，则什么都不做
    if (downloader == nil) {
        NSLog(@"没有下载操作，无法暂停");
        return;
    }
    
    [downloader pause];
    
    // 删除缓存池中的下载操作
    [self.downloadCache removeObjectForKey:netUrl];
}

@end
