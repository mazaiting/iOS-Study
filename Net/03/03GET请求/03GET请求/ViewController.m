//
//  ViewController.m
//  03GET请求
//
//  Created by mazaiting on 18/1/5.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self get];
    [self post];
}

// GET请求
- (void)get {
    NSString *name = @"张三";
    NSString *pwd = @"zhang";
    NSString *strUrl = [NSString stringWithFormat:@"http://127.0.0.1/php/login.php?username=%@&password=%@", name, pwd];
    
    // 对汉字进行转义
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"%@", strUrl);
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
         if (connectionError) {
             NSLog(@"连接错误 %@", connectionError);
             return;
         }
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if (httpResponse.statusCode == 200 || httpResponse.statusCode == 304) {
             // 解析数据
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSLog(@"%@", dict);
         } else {
             NSLog(@"服务器内部错误");
         }
     }];
}

// POST请求
- (void)post {
    NSString *name = @"zhangsan";
    NSString *pwd = @"zhang";
    NSString *str = [NSString stringWithFormat:@"username=%@&password=%@", name, pwd];
    
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/php/login.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置请你去方法
    request.HTTPMethod = @"post";
    // 设置请求体
    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
         if (connectionError) {
             NSLog(@"连接错误 %@", connectionError);
             return;
         }
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if (httpResponse.statusCode == 200 || httpResponse.statusCode == 304) {
             // 解析数据
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSLog(@"%@", dict);
         } else {
             NSLog(@"服务器内部错误");
         }
     }];
}


@end
