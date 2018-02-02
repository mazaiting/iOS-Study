//
//  MTChatViewController.h
//  XMPP
//
//  Created by mazaiting on 18/1/31.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTChatViewController : UIViewController

// 接收目标jid
@property(nonatomic, strong) XMPPJID *userJid;

@end
