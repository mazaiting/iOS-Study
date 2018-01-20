//
//  ViewController.m
//  02JSON
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
                // 解析数据  data 中存储的是JSON形式的字符串
                // JSON序列化 把对象转化成JSON形式的字符串
                // 把JSON形式的字符串转换成OC中的对象
                NSError *error;
                // 解析的JSON字符串，返回的OC对象可能是数组或者字典
                id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (error) {
                    NSLog(@"解析JSON出错 %@", error);
                    return;
                }
                NSLog(@"--%@", json);
            } else {
                NSLog(@"服务器内部错误");
            }
    }];
    
}



@end















