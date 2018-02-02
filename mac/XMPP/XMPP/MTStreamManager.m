//
//  MTStreamManager.m
//  XMPP
//
//  Created by mazaiting on 18/1/30.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "MTStreamManager.h"
// 打印日志需要
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "XMPPLogging.h"

@interface MTStreamManager() <XMPPStreamDelegate, XMPPRosterDelegate>

@end

@implementation MTStreamManager
static MTStreamManager *sInstance;
// 单例
+ (instancetype) sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [MTStreamManager new];
        // 设置日志打印
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        // 设置日志等级
        [DDLog setLogLevel:XMPP_LOG_FLAG_SEND_RECV forClass:self];
    });
    return sInstance;
}

// 懒加载XMPPStream
- (XMPPStream *)xmppStream {
    if (nil == _xmppStream) {
        // 创建
        _xmppStream = [[XMPPStream alloc] init];
        // 设置属性
        // ip
        _xmppStream.hostName = @"127.0.0.1";
        // 端口
        _xmppStream.hostPort = 5222;
        // 设置代理--多播代理
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppStream;
}

// 懒加载断线重连
- (XMPPReconnect *)xmppReconnect {
    if (nil == _xmppReconnect) {
        // 创建对象
        _xmppReconnect = [[XMPPReconnect alloc] initWithDispatchQueue:dispatch_get_main_queue()];
        // 设置参数
        _xmppReconnect.reconnectTimerInterval = 2;
    }
    return _xmppReconnect;
}

// 心跳检测
- (XMPPAutoPing *)xmppAutoPing {
    if (nil == _xmppAutoPing) {
        // 创建心跳检测
        _xmppAutoPing = [[XMPPAutoPing alloc] initWithDispatchQueue:dispatch_get_main_queue()];
        // 设置参数
        _xmppAutoPing.pingInterval = 3;
    }
    return _xmppAutoPing;
}

// 好友列表功能
- (XMPPRoster *)xmppRoster {
    if (nil == _xmppRoster) {
        // 创建对象
        _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:[XMPPRosterCoreDataStorage sharedInstance] dispatchQueue:dispatch_get_global_queue(0, 0)];
        // 设置参数
        // 是否自动查找新的好友数据
        _xmppRoster.autoFetchRoster = YES;
        // 是否自动删除用户存储的数据，不需要
        _xmppRoster.autoClearAllUsersAndResources = NO;
        // 如果自动接收XMPP,会帮我们做一个加好友的操作，代理方法也不会被调用了
        _xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = NO;
        //设置代理，注意让MTStreamManager实现XMPPRosterDelegate协议
        [_xmppRoster addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    }
    return _xmppRoster;
}

// 消息模块
- (XMPPMessageArchiving *)xmppMessageArchiving {
    if (nil == _xmppMessageArchiving) {
        // 创建对象
        _xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:[XMPPMessageArchivingCoreDataStorage sharedInstance] dispatchQueue:dispatch_get_main_queue()];
    }
    return _xmppMessageArchiving;
}

// 自己的个人资料
- (XMPPvCardTempModule *)xmppvCardTempModule {
    if (nil == _xmppvCardTempModule) {
        // 创建对象
        _xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:[XMPPvCardCoreDataStorage sharedInstance] dispatchQueue:dispatch_get_main_queue()];
    }
    return _xmppvCardTempModule;
}

// 指定的用户的个人资料
- (XMPPvCardAvatarModule *)xmppvCardAvatarModule {
    if (nil == _xmppvCardAvatarModule) {
        // 创建
        _xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_xmppvCardTempModule dispatchQueue:dispatch_get_main_queue()];
    }
    return _xmppvCardAvatarModule;
}

// 注册
- (void) registWithName:(NSString *)name andPassword:(NSString *)password {
    // 创建一个JID
    XMPPJID *jid = [XMPPJID jidWithUser:name domain:DO_MAIN resource:nil];
    // 设置MyJID
    [self.xmppStream setMyJID:jid];
    // 设置密码
    self.password = password;
    // 设置状态为注册
    self.connectStatus = connectToSerRegist;
    // 连接到服务器
    [self connectServer];
}

// 登陆
- (void) loginWithName:(NSString *)name andPassword:(NSString *)password {
    // 创建一个JID
    XMPPJID *jid = [XMPPJID jidWithUser:name domain:DO_MAIN resource:nil];
    // 设置MyJID
    [self.xmppStream setMyJID:jid];
    // 设置密码
    self.password = password;
    // 设置状态为注册
    self.connectStatus = connectToSerLogin;
    // 连接到服务器
    [self connectServer];
}

// 连接到服务器
- (void)connectServer {
    // 判断当前是否有连接，如果有则断开
    if ([self.xmppStream isConnected]) {
        // 退出登陆
        [self logout];
    }
    // 异常信息
    NSError *error = nil;
    // 连接服务器
    [self.xmppStream connectWithTimeout:15.0f error:&error];
    // 判断是否连接成功
    if (error) {
        NSLog(@"连接失败");
    }
}

// 退出登陆
- (void) logout {
    // 用户状态类
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    // 向服务器发送离线通知
    [self.xmppStream sendElement:presence];
    // 断开连接
    [self.xmppStream disconnect];
}

// 激活其他模块
- (void) activite {
    // 激活断线重连
    [self.xmppReconnect activate:self.xmppStream];
    // 激活心跳检测
    [self.xmppAutoPing activate:self.xmppStream];
    // 激活好友模块
    [self.xmppRoster activate:self.xmppStream];
    // 激活聊天模块
    [self.xmppMessageArchiving activate:self.xmppStream];
    // 激活个人资料
    [self.xmppvCardTempModule activate:self.xmppStream];
    // 好友的个人资料
    [self.xmppvCardAvatarModule activate:self.xmppStream];
}

#pragma mark 代理方法，连接成功之后回调
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    switch (self.connectStatus) {
        case connectToSerLogin:
        {
            // 错误
            NSError *error = nil;
            // 登陆
            [self.xmppStream authenticateWithPassword:self.password error:&error];
            // 匿名登陆
//            [self.xmppStream authenticateAnonymously:&error];
            // 判断是否登陆成功
            if (error) {
                NSLog(@"登陆失败");
            } else {
                NSLog(@"登陆成功");
                // 登陆成功之后注册其他模块
                [self activite];
            }
        }
            break;
        case connectToSerRegist:
        {
            // 错误
            NSError *error = nil;
            // 注册
            [self.xmppStream registerWithPassword:self.password error:&error];
            // 判断是否注册成功
            if (error) {
                NSLog(@"注册失败");
            }
            // 注册成功之后断开连接
            [self logout];
        }
            break;
        default:
            break;
    }
}

#pragma mark 代理方法，登陆成功之后告诉服务器我要出席
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    // 如果成功，可以出席
    XMPPPresence *presence = [XMPPPresence presence];
    // 添加出席状态
    [presence addChild:[DDXMLElement elementWithName:@"show" stringValue:@"dnd"]];
    [presence addChild:[DDXMLElement elementWithName:@"status" stringValue:@"请勿打扰"]];
    // 告诉服务器我要出席
    [self.xmppStream sendElement:presence];
}

// 通过代理接收数据
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    NSLog(@"接收到的消息: %@", message.body);
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    [noti setAlertBody:[NSString stringWithFormat:@"来自%@ : %@ 消息", message.from, message.body]];
    // 设置appicon图标
    [noti setApplicationIconBadgeNumber:1];
    // 弹出本地通知
    [[UIApplication sharedApplication] presentLocalNotificationNow:noti];
}
@end




















