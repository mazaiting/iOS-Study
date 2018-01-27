//
//  MTSendClientViewController.m
//  Mac服务器
//
//  Created by mazaiting on 18/1/27.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "MTSendClientViewController.h"
@interface MTSendClientViewController ()
// 消息文本框
@property (weak) IBOutlet NSTextField *messageText;
@end
@implementation MTSendClientViewController
- (void)viewDidLoad {
    // 设置标题
    self.title = [NSString stringWithFormat:@"ip: %@, port: %@", self.client.ipAddress, self.client.portNumber];
}
// 发送消息
- (IBAction)toClientMessage:(id)sender {
    // 发送的参数，一个是客户端，一个是消息
    // 通过字典
    NSDictionary *dict = @{
                           @"client":self.client,
                           @"message":self.messageText.stringValue
                           };
    // 发送消息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendMessage" object:nil userInfo:dict];
}

@end
