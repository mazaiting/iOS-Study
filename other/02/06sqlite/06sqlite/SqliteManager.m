//
//  SqliteManager.m
//  06sqlite
//
//  Created by mazaiting on 18/1/25.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "SqliteManager.h"
// 数据库
sqlite3 *database;
// 预编译SQL语句产生的结果
sqlite3_stmt *stmt;
@implementation SqliteManager

// 获取生成路径
- (NSString *)path {
    NSArray *documentArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentArr firstObject];
    // 其中person是数据库名称，".db"是数据库的后缀
    NSString *path = [NSString stringWithFormat:@"%@/person.db", documentPath];
    NSLog(@"数据库路径: %@", path);
    return path;
}
// 创建数据库
- (void)createDb {
    /*  
        第一个参数：数据库文件名，(UTF-8)
        第二个参数：数据库句柄
     */
    int result = sqlite3_open([[self path] UTF8String], &database);
    if (result != SQLITE_OK) {
        NSLog(@"打开数据库失败");
    }
    NSLog(@"打开数据库成功");
}
// 创建表
- (void)createTable {
    char *error;
    const char *sql = "create table if not exists person(id integer primary key autoincrement, name char, sex char)";
    /*
        第一个参数：一个打开的数据库
        第二个参数：要执行的sql语句
        第三个参数：回调方法
        第四个参数：第一个参数的回调
        第五个参数：错误信息
     */
    int result = sqlite3_exec(database, sql, NULL, NULL, &error);
    if (result != SQLITE_OK) {
        NSLog(@"创建表失败： %s", error);
    } else {
        NSLog(@"创建表成功");
    }
}
// 插入数据
- (void)insertData {
    const char *sql = "insert into person(name,sex) values('mazaiting','male');";
    /*
        第一个参数：一个打开的数据库
        第二个参数：要执行的sql语句
        第三个参数：执行sql语句的字节数
        第四个参数：状态句柄
        第五个参数：未使用，传入NULL
     */
    int result = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        NSLog(@"添加失败, %d", result);
    } else {
        // 执行sql语句
        sqlite3_step(stmt);
        NSLog(@"插入成功");
    }
}

// 查询数据
- (void)queryData {
    const char *sql = "select * from person";
    int result = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        NSLog(@"查询失败：%d", result);
    } else {
        // 查询结果可能不止一条， 知道sqlite3_step(stmt) != SQLITE_ROW,查询结束
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            // 查询第0行
            int id = sqlite3_column_int(stmt, 0);
            // 查询第1行
            char *name = (char *)sqlite3_column_text(stmt, 1);
            // 查询第2行
            char *sex = (char *)sqlite3_column_text(stmt, 2);
            NSLog(@"查询成功：%d---%s---%s", id, name, sex);
        }
    }
}

// 修改数据
- (void)updateData {
    const char *sql = "update person set name='zaiting' where name='mazaiting'";
    int result = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        NSLog(@"修改失败：%d", result);
    } else {
        sqlite3_step(stmt);
        NSLog(@"修改成功");
    }
}

// 删除数据
- (void)deleteData {
    const char *sql = "delete from person where sex='male'";
    int result = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        NSLog(@"删除失败：%d", result);
    } else {
        sqlite3_step(stmt);
        NSLog(@"删除成功");
    }
}

// 关闭数据库
- (void)closeDb {
    // 销毁stmt，回收资源
    sqlite3_finalize(stmt);
    // 关闭数据库
    sqlite3_close(database);
}

@end
