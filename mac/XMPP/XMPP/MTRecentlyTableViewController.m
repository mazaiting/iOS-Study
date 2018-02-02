//
//  MTRecentlyTableViewController.m
//  XMPP
//
//  Created by mazaiting on 18/2/1.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "MTRecentlyTableViewController.h"
#import "MTChatViewController.h"

@interface MTRecentlyTableViewController () <NSFetchedResultsControllerDelegate, XMPPvCardAvatarDelegate>
// 控制器查询数据
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
// 最近联系人数组
@property (nonatomic, strong) NSArray *recentlyArrs;
@end

@implementation MTRecentlyTableViewController

// 懒加载数组
- (NSArray *)recentlyArrs {
    if (nil == _recentlyArrs) {
        _recentlyArrs = [NSArray array];
    }
    return _recentlyArrs;
}

// 懒加载控制器
- (NSFetchedResultsController *)fetchedResultsController {
    if (nil == _fetchedResultsController) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject" inManagedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
        [fetchRequest setEntity:entity];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mostRecentMessageTimestamp" ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        // 创建控制器
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:@"Recently"];
        // 设置代理
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}

// NSFetchedResultsController代理
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // 数据获取
    self.recentlyArrs = self.fetchedResultsController.fetchedObjects;
    // 数据刷新
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置代理
    [[MTStreamManager sharedManager].xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 清楚缓存数据
    [NSFetchedResultsController deleteCacheWithName:@"Recently"];
    // 数据查询
    [self.fetchedResultsController performFetch:nil];
    // 数组赋值
    self.recentlyArrs = self.fetchedResultsController.fetchedObjects;
    // 刷新列表
    [self.tableView reloadData];
}

#pragma mark - Table view data source
// 返回数组长度
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recentlyArrs.count;
}

// 返回Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取数据
    XMPPMessageArchiving_Contact_CoreDataObject *contact = self.recentlyArrs[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Recently_Cell"];
    
    // 设置Cell
    UIImageView *icon = (UIImageView *)[cell viewWithTag:1001];
    UILabel *name = (UILabel *)[cell viewWithTag:1002];
    UILabel *lastMessage= (UILabel *)[cell viewWithTag:1003];
    // JID
    name.text = contact.bareJidStr;
    // 最后一条消息
    lastMessage.text = contact.mostRecentMessageBody;
    // 设置头像
    icon.image = [UIImage imageWithData:[[MTStreamManager sharedManager].xmppvCardAvatarModule photoDataForJID:contact.bareJid]];
    
    return cell;
}

// 跳转到聊天页面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell {
    // 获取数据
    XMPPMessageArchiving_Contact_CoreDataObject *contact = self.recentlyArrs[[self.tableView indexPathForCell:cell].row];
    // 设置JID
    MTChatViewController *chatVC = segue.destinationViewController;
    
    chatVC.userJid = contact.bareJid;
}

// 更新数据
- (void)xmppvCardAvatarModule:(XMPPvCardAvatarModule *)vCardTempModule didReceivePhoto:(UIImage *)photo forJID:(XMPPJID *)jid {
    // 数据刷新
    [self.tableView reloadData];
}

// 加入多人聊天室
- (IBAction)addRoom:(id)sender {
    XMPPJID *jid = [XMPPJID jidWithUser:@"love" domain:@"tochat.mazaiting.com" resource:nil];
    // 加入到房间
    [[MTMucRoomManager sharedMucRoom] joinOrCreateWithRoomJid:jid andNickName:@"小鱼"];
}

@end
