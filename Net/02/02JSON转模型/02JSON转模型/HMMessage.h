//
//  HMMessage.h
//  02JSON转模型
//
//  Created by mazaiting on 18/1/4.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMMessage : NSObject

@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) int messageId;

+ (instancetype)messageWithDic:(NSDictionary *)dic;
@end
