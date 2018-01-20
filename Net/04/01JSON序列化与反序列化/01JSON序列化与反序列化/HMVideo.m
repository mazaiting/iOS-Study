//
//  HMVideo.m
//  01JSON序列化与反序列化
//
//  Created by mazaiting on 18/1/7.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "HMVideo.h"

@implementation HMVideo{
    BOOL _isYellow;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@{videoName:%@,size:%d,author:%@,_isYellow:%d", [super description],self.videoName, self.size, self.author, _isYellow];
}

@end
