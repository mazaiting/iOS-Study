//
//  MTCoreDataManager.m
//  07CoreData
//
//  Created by mazaiting on 18/1/26.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "MTCoreDataManager.h"

@implementation MTCoreDataManager
static MTCoreDataManager *sharedManager;
// 单例
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [MTCoreDataManager new];
    });
    return sharedManager;
}

// 创建一个管理对象上下文
- (NSManagedObjectContext *)managerContext {
    if (_managerContext == nil) {
        // 创建对象
        _managerContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        // 给上下文设置持久化存储协调器
        // 模型文件url
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Person" withExtension:@"momd"];
        // 根据url获取到模型文件
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
        // 设置模型文件
        NSPersistentStoreCoordinator *persitent = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        // 数据路径放置在沙盒
        NSArray *documentArr =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [[documentArr lastObject] stringByAppendingPathComponent:@"person.db"];
        // 形如 /Users/mazaiting/Library/Developer/CoreSimulator/Devices/88EDB5E4-B3DC-46A9-8FDD-4AAC70D2ECFA/data/Containers/Data/Application/5724BAF7-3BB5-4699-BD51-03C5FC1093BF/Documents/person.db
        NSLog(@"%@", documentPath);
//        NSString *documentPath = @"/Users/mazaiting/Desktop/person/person.db";
        // 获取文件路径的url
        NSURL *pathUrl = [NSURL fileURLWithPath:documentPath];
        // 添加数据库文件路径
        [persitent addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:pathUrl options:nil error:nil];
        // 设置持久化存储协调器
        [_managerContext setPersistentStoreCoordinator:persitent];
    }
    return _managerContext;
}

@end

















