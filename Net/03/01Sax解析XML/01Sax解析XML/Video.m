//
//  Video.m
//  01Sax解析XML
//
//  Created by mazaiting on 18/1/5.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "Video.h"

@implementation Video

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)videoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (NSString *)time {
    int len = self.length.intValue;
    return [NSString stringWithFormat:@"%02d:%02d:%02d:", len / 3600, (len %3600) / 60, (len % 60) ];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ : %p> { videoId : %@, name : %@, length : %@, videoURL : %@, imageURL : %@, desc : %@, teacher : %@}", [self class], self, self.videoId, self.name, self.length, self.videoURL, self.imageURL, self.desc, self.teacher];
}


@end
