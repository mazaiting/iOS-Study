//
//  ViewController.m
//  02Socket
//
//  Created by mazaiting on 18/1/3.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface ViewController ()

@end

@implementation ViewController

// Socket 套接字
// 纯C语言的，跨平台的
// HTTP协议是基于Socket的

// 0. 导入头文件
// 1. 创建Socket
// 2. 连接到服务器
// 3. 发送数据给服务器
// 4. 从服务器接收数据
// 5. 关闭连接

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    1. 创建Socket
//    domain 协议域， 常用AF_INET，指定IPv4
//    type socket类型. SOCK_STREAM 流式， SOCK_DGRAM 数据报
//    protocol IPPROTO_TCP TCP方式，可以设置为0，根据第二参数来自动确定第二个参数
//    返回值，如果创建成功返回的是socket的描述符，失败返回-1
//    int socket(int domain, int type, int protocol);
    int clientSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    
//    2. 连接服务器
//    sockfd 套接字描述符
//    serv_addr 指向数据结构sockaddr的指针，其中包括目的端口和IP地址
//    addrlen 参数二serv_addr的长度，可以通过sizeof(struct sockaddr)获取
//    成功返回0 失败返回非0
//    int connect(int sockfd, struct sockaddr *serv_addr, int addrlen);
//    创建结构体
    struct sockaddr_in addr;
//    指定IPv4地址
    addr.sin_family = AF_INET;
//    指定IP地址
    addr.sin_addr.s_addr = inet_addr("127.0.0.1");
//    指定端口
    addr.sin_port = htons(12345);
//    连接
    int result = connect(clientSocket, (const struct sockaddr *)&addr, sizeof(addr));
    
/** 一、判断是否连接成功
    if (0 == result) {
//        打开本机模拟服务器端口
//        打开Netcat 模拟服务器
//        nc -lk 12345
//        nc-->Netcat终端下用于调试和检查网络的工具
        NSLog(@"成功");
    } else {
//        服务器未打开时连接失败
        NSLog(@"失败");
    }
*/
    
    if (result != 0) {
        NSLog(@"失败");
    }
    
    // 3. 发送消息
//    1). 套接字id
//    2). 发送的消息
//    3). 发送的消息的大小,不是字节数，而是字符数
//    4). 阻塞或者不阻塞，一般填0
//    返回值，成功返回发送出去的字节数，失败返回-1
//    ssize_t	send(int s, const void *msg, size_t len, int flags) __DARWIN_ALIAS_C(send);
    const char *msg = "Hello world!";
    ssize_t sendCount = send(clientSocket, msg, strlen(msg), 0);
    NSLog(@"发送的字节数 %zd", sendCount);
    
    // 4. 接收服务器返回的数据
    // 返回的是实际接受的字节个数
    // 定义字符数组
    uint8_t buffer[1024];
    ssize_t recvCount = recv(clientSocket, buffer, 1024, 0);
    NSLog(@"发送的字节数 %zd", recvCount);
    
    // 把字节数组转换成字符串
    // 二进制数据
    NSData *data = [NSData dataWithBytes:buffer length:recvCount];
    NSString *recvMsg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到的消息 : %@", recvMsg);
    
    // 5. 关闭连接
    close(clientSocket);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end










