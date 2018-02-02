
//
//  MTMucRoomManager.m
//  XMPP
//
//  Created by mazaiting on 18/2/1.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "MTMucRoomManager.h"

@interface MTMucRoomManager () <XMPPMUCDelegate, XMPPRoomDelegate>

// 用来存储聊天室的字典
@property (nonatomic, strong) NSMutableDictionary *roomDict;

@end

@implementation MTMucRoomManager

static MTMucRoomManager *sInstance;
// 单例
+ (instancetype)sharedMucRoom {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [MTMucRoomManager new];
    });
    return sInstance;
}

// 懒加载字典
- (NSMutableDictionary *)roomDict {
    if (nil == _roomDict) {
        // 创建字典
        _roomDict = [NSMutableDictionary dictionary];
    }
    return _roomDict;
}

// 多用户聊天功能类
- (XMPPMUC *)xmppMuc {
    if (nil == _xmppMuc) {
        // 创建
        _xmppMuc = [[XMPPMUC alloc] initWithDispatchQueue:dispatch_get_main_queue()];
        // 设置代理
        [_xmppMuc addDelegate:self delegateQueue:dispatch_get_main_queue()];
        // 激活
        [_xmppMuc activate:[MTStreamManager sharedManager].xmppStream];
    }
    return _xmppMuc;
}

// 聊天室功能类
- (XMPPRoom *)xmppRoom {
    if (nil == _xmppRoom) {
        // 创建对象
        _xmppRoom = [[XMPPRoom alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    }
    return _xmppRoom;
}

// 加入或者创建聊天室
- (void)joinOrCreateWithRoomJid:(XMPPJID *)roomJid andNickName:(NSString *)nickName {
    // 创建房间
    XMPPRoom *room = [[XMPPRoom alloc] initWithRoomStorage:[XMPPRoomCoreDataStorage sharedInstance] jid:roomJid dispatchQueue:dispatch_get_main_queue()];
    // 激活
    [room activate:[MTStreamManager sharedManager].xmppStream];
    // 存放在字典中
    self.roomDict[roomJid] = room;
    // 加入房间
    [room joinRoomUsingNickname:nickName history:nil];
    // 设置代理
    [room addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark 回调
// 加入
- (void)xmppRoomDidJoin:(XMPPRoom *)sender {
    // 对房间进行配置
    [sender configureRoomUsingOptions:nil];
    // 测试方法--需先要在控制台中创建分组与房间
    XMPPJID *jid = [XMPPJID jidWithUser:@"linghaoyu9" domain:DO_MAIN resource:nil];
    // 邀请加入
    [sender inviteUser:jid withMessage:@"来聊天"];
}

// 创建
- (void)xmppRoomDidCreate:(XMPPRoom *)sender {
    
}

@end
