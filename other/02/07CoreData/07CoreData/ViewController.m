//
//  ViewController.m
//  07CoreData
//
//  Created by mazaiting on 18/1/26.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import "MTCoreDataManager.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController
// 插入
- (IBAction)insert {
    // 通过实体描述出实体对象
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:[MTCoreDataManager sharedManager].managerContext];
    person.name = @"mazaiting";
    person.age = @(24);
    // 提交数据
    [[MTCoreDataManager sharedManager].managerContext save:nil];
    NSLog(@"插入成功");
}
// 查询
- (IBAction)fetch {
    // 查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // 设置参数
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:[MTCoreDataManager sharedManager].managerContext];
    // 设置实体
    request.entity = entity;
    // 谓词--类似于sql中的where
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age = %d", 24];
    // 设置谓词
    request.predicate = predicate;
    // 排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
    // 设置排序
    request.sortDescriptors = @[sort];
    // 执行查询请求
    NSArray *arr = [[MTCoreDataManager sharedManager].managerContext executeFetchRequest:request error:nil];
    if (arr.count == 0) {
        NSLog(@"表中无数据");
    }
    // 打印结果
    for (Person *person in arr) {
        NSLog(@"name: %@, age: %@", person.name, person.age);
    }
}
// 更新
- (IBAction)update {
    // 创建请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设置参数
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:[MTCoreDataManager sharedManager].managerContext];
    // 设置实体
    request.entity = entity;
    // 设置谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age = %d", 24];
    request.predicate = predicate;
    // 执行请求
    NSArray *arr = [[MTCoreDataManager sharedManager].managerContext executeFetchRequest:request error:nil];
    
    for (Person *person in arr) {
        person.name = @"zaiting";
    }
    
    [[MTCoreDataManager sharedManager].managerContext save:nil];
    NSLog(@"更新成功");
}
// 删除
- (IBAction)delete {
    // 创建请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 获取实体
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:[MTCoreDataManager sharedManager].managerContext];
    // 设置实体
    request.entity = entity;
    // 创建谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age = %d", 24];
    // 设置谓词
    request.predicate = predicate;
    // 执行命令
    NSArray *arr = [[MTCoreDataManager sharedManager].managerContext executeFetchRequest:request error:nil];
    for (Person *person in arr) {
        [[MTCoreDataManager sharedManager].managerContext deleteObject:person];
    }
    [[MTCoreDataManager sharedManager].managerContext save:nil];
    NSLog(@"删除成功");
}


@end
