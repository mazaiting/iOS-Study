//
//  MTDownloader.h
//  01Downloader
//
//  Created by mazaiting on 18/1/8.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTDownloader : NSOperation
// 下载方法
// netUrl 下载的网络连接
// successBlock 成功回调block
// processBlock 进度对调block
// errorBlock 异常回调block
+ (instancetype)download:(NSString *)netUrl successBlock:(void(^)(NSString *path))successBlock processBlock:(void(^)(float process))processBlock errorBlock:(void(^)(NSError *error))errorBlock;

// 暂停下载
- (void)pause;
@end
