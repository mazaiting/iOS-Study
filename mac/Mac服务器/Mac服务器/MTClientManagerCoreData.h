//
//  MTClientManagerCoreData.h
//  Mac服务器
//
//  Created by mazaiting on 18/1/27.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface MTClientManagerCoreData : NSObject

// 管理对象上下文
@property (nonatomic, strong)NSManagedObjectContext *managerContext;

// 单例
+ (instancetype)sharedManager;

@end
