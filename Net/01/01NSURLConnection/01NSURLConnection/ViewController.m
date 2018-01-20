//
//  ViewController.m
//  01NSURLConnection
//
//  Created by mazaiting on 18/1/3.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

/**
 1. NSURLConnection使用
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    // 请求，内部类创建
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 1）请求
    // 2) 队列
    // 3）block 回调
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        // response 服务器返回的响应头
        // data 服务器返回的返回体
        // connectionError 连接错误
        if (!connectionError) {
            // 把二进制数据转换为NSString
            NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", html);
        } else {
            // 第一次连接错误，原因是ATS
            NSLog(@"连接错误 %@", connectionError);
        }
        
    }];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end












