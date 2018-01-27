//
//  MTCoreDataManager.h
//  07CoreData
//
//  Created by mazaiting on 18/1/26.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface MTCoreDataManager : NSObject

// 创建一个管理对象上下文
@property (nonatomic, strong) NSManagedObjectContext *managerContext;

// 单例
+ (instancetype)sharedManager;
@end
