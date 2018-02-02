//
//  MTMucRoomManager.h
//  XMPP
//
//  Created by mazaiting on 18/2/1.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTMucRoomManager : NSObject
// 多用户聊天功能类
@property (nonatomic, strong) XMPPMUC *xmppMuc;
// 聊天室功能类
@property (nonatomic, strong) XMPPRoom *xmppRoom;

// 单例
+ (instancetype)sharedMucRoom;

// 加入或者创建聊天室
- (void)joinOrCreateWithRoomJid:(XMPPJID *)roomJid andNickName:(NSString *)nickName;
@end
