//
//  MTSendClientViewController.h
//  Mac服务器
//
//  Created by mazaiting on 18/1/27.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Client.h"
@interface MTSendClientViewController : NSViewController

// 接收指定的客户端
@property (nonatomic, strong) Client *client;

@end
