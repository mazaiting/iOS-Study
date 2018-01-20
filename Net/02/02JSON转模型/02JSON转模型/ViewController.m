//
//  ViewController.m
//  02JSON转模型
//
//  Created by mazaiting on 18/1/4.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import "HMMessage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/demo.json"];
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
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             // 字典转模型
             HMMessage *msg = [HMMessage messageWithDic:dic];
             NSLog(@"%@", msg);
         } else {
             NSLog(@"服务器内部错误");
         }
     }];




}


@end
