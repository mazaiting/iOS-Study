//
//  ViewController.m
//  03模拟聊天
//
//  Created by mazaiting on 18/1/3.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ipView;
@property (weak, nonatomic) IBOutlet UITextField *portView;
@property (weak, nonatomic) IBOutlet UITextField *sendMsgView;
@property (weak, nonatomic) IBOutlet UILabel *recvMsgView;

@property (nonatomic, assign) int clientSocket;
@end

@implementation ViewController
// 点击连接按钮
- (IBAction)connectClick {
    // 连接服务器
    [self connectIp:self.ipView.text port:[self.portView.text intValue]];
}

// 点击发送按钮
- (IBAction)sendClick {
    self.recvMsgView.text = [self sendAndRecv:self.sendMsgView.text];
}

// 点击关闭按钮
- (IBAction)closeClick {
    close(self.clientSocket);
    NSLog(@"关闭连接");
}

// 连接服务器
- (BOOL)connectIp:(NSString *)ip port:(int)port {
    int clientSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    self.clientSocket = clientSocket;
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = inet_addr(ip.UTF8String);
    addr.sin_port = htons(port);
    
    int result = connect(clientSocket, (const struct sockaddr *) &addr, sizeof(addr));
    if (result == 0) {
        return YES;
    } else {
        return NO;
    }
}

// 发送和接收数据
- (NSString *) sendAndRecv:(NSString *)sendMsg {
    const char *msg = sendMsg.UTF8String;
    ssize_t sendCount = send(self.clientSocket, msg, strlen(msg), 0);
    NSLog(@"发送的字节数 %zd", sendCount);
    
    uint8_t buffer[1024];
    ssize_t recvCount = recv(self.clientSocket, buffer, sizeof(buffer), 0);
    NSLog(@"接收的字节数 %zd", recvCount);
    
    NSData *data = [NSData dataWithBytes:buffer length:recvCount];
    NSString *recvMsg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return recvMsg;
}









- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end






