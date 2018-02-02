//
//  MTChatViewController.m
//  XMPP
//
//  Created by mazaiting on 18/1/31.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "MTChatViewController.h"

@interface MTChatViewController ()<NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, XMPPvCardAvatarDelegate>
// 消息列表
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// 消息文本框
@property (weak, nonatomic) IBOutlet UITextField *message;
// 消息列表查询控制器
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
// 消息数组
@property (nonatomic, strong) NSArray *chatArrs;
@end

@implementation MTChatViewController

// 懒加载数组
- (NSArray *)chatArrs {
    if (nil == _chatArrs) {
        _chatArrs = [NSArray array];
    }
    return _chatArrs;
}

// 懒加载fetchedResultsController
- (NSFetchedResultsController *)fetchedResultsController {
    if (nil == _fetchedResultsController) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@", self.userJid.bare];
        [fetchRequest setPredicate:predicate];
        // Specify how the fetched objects should be sorted
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:@"messages"];
        
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 清除缓存
    [NSFetchedResultsController deleteCacheWithName:@"messages"];
    [[MTStreamManager sharedManager].xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    // 查询聊天记录
    [self.fetchedResultsController performFetch:nil];
    // 数据赋值
    self.chatArrs = self.fetchedResultsController.fetchedObjects;
    // 刷新
    [self.tableView reloadData];
    if (self.chatArrs.count > 5) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.chatArrs.count - 1 inSection:0];
        // 滚动到最底部
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

// 数据改变调用
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"接收到了新消息");
    // 排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    // 获得排序后的数据
    self.chatArrs = [self.fetchedResultsController.fetchedObjects sortedArrayUsingDescriptors:@[sort]];
    // 刷新
    [self.tableView reloadData];
    // 滚动到最底部
    if (self.chatArrs.count > 5) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.chatArrs.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark tableView代理方法
// 返回数据总数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatArrs.count;
}
// 返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return 80.0;
}
// 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取数据
    XMPPMessageArchiving_Message_CoreDataObject *msg = self.chatArrs[indexPath.row];
    // 创建cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:msg.isOutgoing?@"Right_Cell":@"Left_Cell"];
    // 赋值
    UILabel *message = (UILabel *)[cell viewWithTag:1002];
    message.text = msg.body;
    // 头像设置
    UIImageView *icon = (UIImageView *)[cell viewWithTag:1001];
    // 判断是谁发出的消息
    if (msg.isOutgoing) {
        // 自己的头像
        icon.image = [UIImage imageWithData:[MTStreamManager sharedManager].xmppvCardTempModule.myvCardTemp.photo];
    } else {
        // 好友的头像
        icon.image = [UIImage imageWithData:[[MTStreamManager sharedManager].xmppvCardAvatarModule photoDataForJID:msg.bareJid]];
    }
    // 返回cell
    return cell;
}

// 滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 停止编辑
    [self.message endEditing:YES];
}

// 发送消息 -- 按返回键的时候
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 发消息--私聊
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.userJid];
    // 发消息--群聊
//    XMPPMessage *message = [XMPPMessage messageWithType:@"group" to:self.userJid];
    // 设置消息
    [message addBody:self.message.text];
    // 发消息
    [[MTStreamManager sharedManager].xmppStream sendElement:message];
    // 刷新数据
    [self.tableView reloadData];
    // 置空
    self.message.text = @"";
    return YES;
}

// 刷新数据
- (void)xmppvCardAvatarModule:(XMPPvCardAvatarModule *)vCardTempModule didReceivePhoto:(UIImage *)photo forJID:(XMPPJID *)jid {
    NSLog(@"genghuantouxiang");
    // 数据刷新
    [self.tableView reloadData];
}

@end
