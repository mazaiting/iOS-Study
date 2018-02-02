//
//  MTContactTableTableViewController.m
//  XMPP
//
//  Created by mazaiting on 18/1/30.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "MTContactTableViewController.h"
#import "MTChatViewController.h"

@interface MTContactTableViewController () <XMPPRosterDelegate,NSFetchedResultsControllerDelegate>
// 查询控制器，用来查询好友
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
// 好友列表数组
@property (nonatomic, strong) NSArray *contactArrs;
@end

@implementation MTContactTableViewController

// 懒加载联系人数组
- (NSArray *)contactArrs {
    if (nil == _contactArrs) {
        _contactArrs = [NSArray array];
    }
    return _contactArrs;
}

// 懒加载fetchedResultsController，执行查询操作
- (NSFetchedResultsController *)fetchedResultsController {
    if (nil == _fetchedResultsController) {
        // 创建一个查询请求
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // 实体
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:[XMPPRosterCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
        // 谓词, 查询只有双方都是对方的好友的人
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"subscription = %@", @"both"];
        // 排序, 根据jidStr进行升序排列
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"jidStr" ascending:YES];
        // 设置实体
        fetchRequest.entity = entity;
        // 设置谓词
        fetchRequest.predicate = predicate;
        // 设置排序
        fetchRequest.sortDescriptors = @[sortDescriptor];
        // 创建fetchedResultsController对象
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[XMPPRosterCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:@"contacts"];
        // 设置代理, 实现协议NSFetchedResultsControllerDelegate
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 删除CoreData中的缓存
    [NSFetchedResultsController deleteCacheWithName:@"contacts"];
    // 好友代理设置, 实现XMPPRosterDelegate
    [[MTStreamManager sharedManager].xmppRoster addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    // 执行查询操作, 查询到之后将数据保存在了fetchedObjects变量中
    [self.fetchedResultsController performFetch:nil];
    // 获取到数据
    self.contactArrs = self.fetchedResultsController.fetchedObjects;
    // 刷新数据
    [self.tableView reloadData];
}

#pragma mark - NSFetchedResultsController协议
// 当CoreData数据发生变化会调用该代理方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"数据发生改变");
    // 最新的列表
    self.contactArrs = self.fetchedResultsController.fetchedObjects;
    // 刷新数据
    [self.tableView reloadData];
}

#pragma mark - Table view data source
// 返回TableView中的条目总数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactArrs.count;
}

// 设置TableViewCell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

// 为TableViewCell赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取TableViewCell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Contact_Cell"];
    // 获取对应行的联系人数据
    XMPPUserCoreDataStorageObject *contact = self.contactArrs[indexPath.row];
    
    // 给Cell赋值
    // 设置JID
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1002];
    nameLabel.text = contact.jidStr;
    // 设置头像
    UIImageView *icon = (UIImageView *)[cell viewWithTag:1001];
    icon.image = [UIImage imageWithData:[[MTStreamManager sharedManager].xmppvCardAvatarModule photoDataForJID:contact.jid]];
    
    return cell;
}

// 添加好友
- (IBAction)addFriends:(id)sender {
    // 创建XMPPJID
    XMPPJID *jid = [XMPPJID jidWithUser:@"linghaoyu9" domain:DO_MAIN resource:nil];
    // 添加好友
//    [[MTStreamManager sharedManager].xmppRoster addUser:jid withNickname:@"加好友"];
    [[MTStreamManager sharedManager].xmppRoster subscribePresenceToUser:jid];
}

// 同意添加好友
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    // 创建XMPPJID
    XMPPJID *jid = [XMPPJID jidWithUser:@"linghaoyu9" domain:DO_MAIN resource:nil];
    // 同意添加对方为好友
    [[MTStreamManager sharedManager].xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
//    // 刷新数据
//    [self.tableView reloadData];
}

// 左滑删除好友
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取数据
    XMPPUserCoreDataStorageObject *contact = self.contactArrs[indexPath.row];
    // 判断是否为删除
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除好友
        [[MTStreamManager sharedManager].xmppRoster removeUser:contact.jid];
    }
}

// 跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell {
    // 获取数据
    XMPPUserCoreDataStorageObject *contact = self.contactArrs[[self.tableView indexPathForCell:cell].row];
    // 获取目标控制器
    MTChatViewController *chatVC = segue.destinationViewController;
    // 把目标的jid传给聊天界面
    chatVC.userJid = contact.jid;
}

@end
