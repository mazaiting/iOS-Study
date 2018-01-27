//
//  MTClientManagerCoreData.m
//  Mac服务器
//
//  Created by mazaiting on 18/1/27.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "MTClientManagerCoreData.h"

@implementation MTClientManagerCoreData
static MTClientManagerCoreData *sharedManager;
// 单例
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [MTClientManagerCoreData new];
    });
    return sharedManager;
}

// 管理对象上下文
- (NSManagedObjectContext *)managerContext {
    if (nil == _managerContext) {
        _managerContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        // 创建模型文件
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Client" withExtension:@"momd"]];
        // 创建持久化存储协调器
        NSPersistentStoreCoordinator *persistener = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        // 数据库文件地址
        NSString *path = @"/Users/mazaiting/Desktop/client/client.db";
        NSURL *url = [NSURL fileURLWithPath:path];
        [persistener addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
        
        // 设置持久化存储协调器
        [_managerContext setPersistentStoreCoordinator:persistener];
    }
    return _managerContext;
}


@end
