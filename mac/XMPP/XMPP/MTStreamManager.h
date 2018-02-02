//
//  MTStreamManager.h
//  XMPP
//
//  Created by mazaiting on 18/1/30.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DO_MAIN @"mazaiting.com"

@interface MTStreamManager : NSObject

typedef NS_ENUM(NSInteger, connectToServer) {
    connectToSerLogin, // 登陆
    connectToSerRegist // 注册
};

// 单例
+ (instancetype) sharedManager;

// 创建XMPPStream流
@property (nonatomic, strong) XMPPStream *xmppStream;

// 存储密码
@property (nonatomic, copy) NSString *password;

// 区别注册还是登陆
@property (nonatomic) connectToServer connectStatus;

// 创建自动重连对象
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;

// 创建心跳检测对象
@property (nonatomic, strong) XMPPAutoPing *xmppAutoPing;

// 创建好友列表功能模块
@property (nonatomic, strong) XMPPRoster *xmppRoster;

// 创建聊天功能模块
@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchiving;

// 自己个人资料的功能类
@property (nonatomic, strong) XMPPvCardTempModule *xmppvCardTempModule;

// 好友个人资料
@property (nonatomic, strong) XMPPvCardAvatarModule *xmppvCardAvatarModule;

// 注册
- (void) registWithName:(NSString *)name andPassword:(NSString *)password;

// 登陆
- (void) loginWithName:(NSString *)name andPassword:(NSString *)password;

@end
