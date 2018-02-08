//
//  ViewController.m
//  08FMDB使用
//
//  Created by mazaiting on 18/2/7.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
#import <sqlite3.h>
@interface ViewController ()
// 数据库对象
@property (nonatomic, strong) FMDatabase *fmDatabase;
@end

@implementation ViewController

// 打开数据库
- (IBAction)openDb:(id)sender {
    // 创建数据库路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"data.sqlite"];
    // 创建数据库对象
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    self.fmDatabase = db;
    // 打开数据库，true，打开成功；false，打开失败
    BOOL isSuccess = [db open];
    // 判断是否打开成功
    if (isSuccess) {
        NSLog(@"打开数据库成功");
        NSLog(@"数据库路径：%@", path);
    } else {
        NSLog(@"打开数据库失败");
    }
}
// 创建表
- (IBAction)createTable:(id)sender {
    // 创建表,执行sql语句，增删改相同，查询不一样
    NSString *sql = @"create table if not exists test(id integer primary key autoincrement, name text, age integer);";
    // 执行创建表命令，true, 创建成功；false，创建失败
    BOOL isSuccess = [self.fmDatabase executeUpdate:sql];
    if (isSuccess) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
    }
}
// 插入数据
- (IBAction)insert:(id)sender {
    // 向表中添加100条数据
    for (int i = 0; i < 100; i++) {
        // 名称设置
        NSString *name = [NSString stringWithFormat:@"item-%d", i];
        // 随机生成20--25岁之间的年龄
        NSInteger age = arc4random_uniform(5) + 20;
        // sql语句拼接
        NSString *sql = [NSString stringWithFormat:@"insert into test(name,age) values('%@',%zd);", name, age];
        // 执行插入语句
        BOOL isSuccess = [self.fmDatabase executeUpdate:sql];
        // 判断是否添加成功
        if (isSuccess) {
            NSLog(@"添加成功");
        } else {
            NSLog(@"添加失败");
        }
    }
}
// 查询数据
- (IBAction)query:(id)sender {
    // 查询语句
    NSString *sql = @"select name,age from test where age = 23;";
    // 执行查询语句
    FMResultSet *result = [self.fmDatabase executeQuery:sql];
    // 遍历查询结果
    while ([result next]) {
        // name
        NSString *name = [result stringForColumnIndex:0];
        // age
        NSInteger age = [result intForColumnIndex:1];
        NSLog(@"name = %@, age = %ld.", name, age);
    }
}
// 更新数据
- (IBAction)update:(id)sender {
    // 修改语句
    NSString *sql = @"update test set age = 30 where age < 22;";
    // 执行sql语句
    BOOL isSuccess = [self.fmDatabase executeUpdate:sql];
    if (isSuccess) {
        NSLog(@"修改数据成功");
    } else {
        NSLog(@"修改数据失败");
    }
}
// 删除数据
- (IBAction)delete:(id)sender {
    // 删除语句
    NSString *sql = @"delete from test where age > 25;";
    // 执行语句
    BOOL isSuccess = [self.fmDatabase executeUpdate:sql];
    if (isSuccess) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

@end


























