//
//  ViewController.m
//  01发送请求
//
//  Created by mazaiting on 18/1/3.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 第一种方式 获取网络数据
    // 无法设置请求头  无法控制缓存  无法设置超时时长
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/demo.json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
  
    NSLog(@"-------------------------------");
    
    
    
    // 第二种方式 获取网络数据
//    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/demo.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    // 设置请求头
    [request setValue:@"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Mobile Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSLog(@"%@", response);
        if (!connectionError) {
            // 判断是否正确接收到服务器返回的数据
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200 || httpResponse.statusCode == 304) {
                // 获取服务器的响应体
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@", str);
            } else {
                NSLog(@"服务器内部错误");
            }
        } else {
            NSLog(@"error： %@", connectionError);
        }
        
    }];
    
    
    
    
    
    
}
@end














