//
//  ViewController.m
//  Mac服务器
//
//  Created by mazaiting on 18/1/27.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import "MTClientManagerCoreData.h"
#import "Client.h"
@interface ViewController ()<GCDAsyncSocketDelegate>
// 输入端口的文本框
@property (weak) IBOutlet NSTextField *port;
// 保留已连接的socket
@property (nonatomic, strong) NSMutableArray *clientArrSocket;
// 创建时钟
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ViewController

// 4. 懒加载clientArrSocket
- (NSMutableArray *)clientArrSocket {
    if (nil == _clientArrSocket) {
        _clientArrSocket = [NSMutableArray array];
    }
    return _clientArrSocket;
}

// 1. 创建服务器连接管道
- (GCDAsyncSocket *)server {
    if (nil == _server) {
        // 创建服务器,并实现代理GCDAsyncSocketDelegate
        _server = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _server;
}

// 2. 点击按钮进行监听
- (IBAction)listenToSocket:(id)sender {
    // 监听并绑定端口
    [self.server acceptOnPort:self.port.intValue error:nil];
    // 5. 连接之后读取数据
    [self readData];
    // 7. 接受指定客户端，在数组中找到这个客户端，并发送消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessageNotification:) name:@"sendMessage" object:nil];
}

// 发送消息
- (void)sendMessageNotification:(NSNotification *)info {
    // 接收参数
    NSDictionary *dict = info.userInfo;
    
    Client *client = dict[@"client"];
    NSString *message = dict[@"message"];
    
    // 在数组中查找ip和端口一直的元素，然后发送消息
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"connectedHost = %@ and connectedPort = %@", client.ipAddress, client.portNumber];
    // 按要求查找指定的数据并且返回给一个数组保存
    NSArray *temp = [self.clientArrSocket filteredArrayUsingPredicate:predicate];
    // 遍历，给指定客户端发送消息
    for (GCDAsyncSocket *socket in temp) {
        [socket writeData:[message dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    }
}

// 3. 代理方法，获取新接入的socket
// sock 服务器的socket
// newSocket 新来的客户端
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    // dos中使用"telnet 127.0.0.1 端口" 连接服务器
    // 存储新接入的客户端
    [self.clientArrSocket addObject:newSocket];
    NSLog(@"%@", newSocket);
    
    // 6. 存储客户端
    Client *client = [NSEntityDescription insertNewObjectForEntityForName:@"Client" inManagedObjectContext:[MTClientManagerCoreData sharedManager].managerContext];
    // 赋值
    client.ipAddress = newSocket.connectedHost;
    client.portNumber = @(newSocket.connectedPort);
    client.connectTime = [NSDate new];
    // 提交保存
    [[MTClientManagerCoreData sharedManager].managerContext save:nil];
    // 通知更多客户端界面刷新数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"moreClientReloaddata" object:nil];
}

// 5. 读取数据
- (void)readData {
    // 初始化Timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(readingData) userInfo:nil repeats:YES];
    //添加到当前的运行循环中
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 停止Timer
- (void)stopTime {
    [self.timer invalidate];
    self.timer = nil;
}

// 读取数据
- (void)readingData {
   // 通过数组遍历调用读取数据的方法
    for (GCDAsyncSocket *newSocket in self.clientArrSocket) {
        // 通过指定newSocket读取数据, 并实现代理方法(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
        [newSocket readDataWithTimeout:-1 tag:0];
    }
}

// 通过代理方法读取数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"客户端发来消息： %@", [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding]);
}



@end
