//
//  HMMessage.m
//  02JSON转模型
//
//  Created by mazaiting on 18/1/4.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "HMMessage.h"

@implementation HMMessage

+ (instancetype)messageWithDic:(NSDictionary *)dic {
    HMMessage *msg = [self new];
    [msg setValuesForKeysWithDictionary:dic];
    return msg;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@{message:%@, messageId:%d", [super description], self.message, self.messageId];
}

@end
