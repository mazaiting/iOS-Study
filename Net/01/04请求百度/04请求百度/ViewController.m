//
//  ViewController.m
//  04请求百度
//
//  Created by mazaiting on 18/1/3.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, assign) int clientSocket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 连接百度的服务器
    BOOL result = [self connectIp:@"220.181.111.188" port:80];
    if (!result) {
        NSLog(@"连接失败");
        return;
    }
    NSLog(@"连接成功");
    
    // 模拟构造Http请求头
    NSString *request = @"GET / HTTP/1.1\r\n"
    "Host: www.baidu.com\r\n"
    "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)\r\n"
    "Connection: keep-alive\r\n"
    "\r\n";
    
    NSLog(@"%@", request);
    // 服务器返回的响应头  响应体
    NSString *response = [self sendAndRecv:request];
    NSLog(@"返回的数据: %@", response);
    
    // 关闭连接
    close(self.clientSocket);
    
    // 截取响应头，只保留响应体， 响应头结束的标识 \r\n\r\n
    // 找指定字符串所在的范围，从它之后的第一个位置开始截取字符串
    NSRange range = [response rangeOfString:@"\r\n\r\n"];
    // 截取响应体
    NSString *html = [response substringFromIndex:range.length + range.location];
    
    // baseURL为html依赖的外部文件所在的地址
    [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
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
    NSMutableData *datas = [NSMutableData data];
    ssize_t recvCount = recv(self.clientSocket, buffer, sizeof(buffer), 0);
    [datas appendBytes:buffer length:recvCount];
    
    while (recvCount != 0) {
        recvCount = recv(self.clientSocket, buffer, sizeof(buffer), 0);
        NSLog(@"接收的字节数 %zd", recvCount);
        [datas appendBytes:buffer length:recvCount];
    }
    
    NSString *recvMsg = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
    return recvMsg;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end















