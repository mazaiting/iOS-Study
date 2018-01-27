//
//  SqliteManager.h
//  06sqlite
//
//  Created by mazaiting on 18/1/25.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SqliteManager : NSObject
// 创建数据库
- (void)createDb;
// 创建表
- (void)createTable;
// 插入数据
- (void)insertData;
// 查询数据
- (void)queryData;
// 修改数据
- (void)updateData;
// 删除数据
- (void)deleteData;
// 关闭数据库
- (void)closeDb;
@end
