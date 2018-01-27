//
//  MTMoreClientViewController.m
//  Mac服务器
//
//  Created by mazaiting on 18/1/27.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "MTMoreClientViewController.h"
#import "MTClientManagerCoreData.h"
#import "Client.h"
#import "MTSendClientViewController.h"

@interface MTMoreClientViewController () <NSTableViewDataSource, NSTableViewDelegate>
// 表格视图
@property (weak) IBOutlet NSTableView *tableView;
// 数据源
@property (nonatomic, strong) NSArray *moreArrEntity;
// 格式化时间工具
@property (nonatomic, strong) NSDateFormatter *formatter;
@end

@implementation MTMoreClientViewController

// 1. 懒加载数组
- (NSArray *)moreArrEntity {
    if (nil == _moreArrEntity) {
        _moreArrEntity = [NSArray array];
    }
    return _moreArrEntity;
}
// 5. 懒加载格式化时间
- (NSDateFormatter *)formatter {
    if (nil == _formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"MM - dd EEEE a HH:mm:ss:SSS";
        _formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        _formatter.weekdaySymbols = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    }
    return _formatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 数据查询
    [self fetchData];
    // 接收通知，刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchData) name:@"moreClientReloaddata" object:nil];
}

// 2. 查询数据库数据
- (void)fetchData {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Client" inManagedObjectContext:[MTClientManagerCoreData sharedManager].managerContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"connectTime" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];

    NSError *error = nil;
    self.moreArrEntity = [[MTClientManagerCoreData sharedManager].managerContext executeFetchRequest:fetchRequest error:&error];
    // 数据刷新
    [self.tableView reloadData];
}

// 3. 返回数组的长度
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.moreArrEntity.count;
}
// 4. tableView的赋值语句
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    Client *client = self.moreArrEntity[row];
    if ([tableColumn.title isEqualToString:@"ip"]) {
        return client.ipAddress;
    }
    if ([tableColumn.title isEqualToString:@"port"]) {
        return client.portNumber;
    }
    if ([tableColumn.title isEqualToString:@"date"]) {
        return [self.formatter stringFromDate:client.connectTime];
    }
    return nil;
}

// 5. 手动跳转
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    // 获取数据
    Client *client = self.moreArrEntity[self.tableView.selectedRow];
    // 跳转
    [self performSegueWithIdentifier:@"sendMessageVC" sender:client];
}

// 6. 实现Segue方法
- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(Client *)client {
    // 拿到目标控制器
    MTSendClientViewController *sendVC = segue.destinationController;
    // 赋值参数
    sendVC.client = client;
}

@end
