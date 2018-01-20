//
//  ViewController.m
//  01JSON序列化与反序列化
//
//  Created by mazaiting on 18/1/7.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import "HMVideo.h"

@interface ViewController ()

@end

@implementation ViewController


// 创建JSON
- (NSData *)createJSON {
    // 1. 自己拼JSON形式字符串
    NSString *jsonStr1 = @"{\"name\":\"zhangsan\",\"age\":\"18\"}";
    // 转换成二进制数据便于传输
    NSData *data = [jsonStr1 dataUsingEncoding:NSUTF8StringEncoding];
    
    // 2. 字典
    NSDictionary *dict = @{@"name":@"zhangsan",@"age":@(28)};
    NSData *data1 = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    NSLog(@"%@", dict);
    
    // 3. 数组
    NSArray *array = @[
                       @{@"name":@"zhangsan",@"age":@(28)},
                       @{@"name":@"lilei",@"age":@(20)}
                       ];
    
    NSData *data2 = [NSJSONSerialization dataWithJSONObject:array options:0 error:NULL];
    NSLog(@"%@", array);
    
    // 4. 自定义对象进行JSON序列化
    HMVideo *video1 = [[HMVideo alloc] init];
    video1.videoName = @"ll-001.avi";
    video1.size = 500;
    video1.author = @"mazaiting";
    // KVC给成员变量赋值
    [video1 setValue:@(NO) forKey:@"_isYellow"];
    NSLog(@"%@", video1);
    
    // 自定义对象不能直接序列化，必须先把自定义对象转换成字典或者数组
//    if (![NSJSONSerialization isValidJSONObject:video1]) {
//        NSLog(@"自定义对象不能序列化");
//        return nil;
//    }
    
    NSDictionary *dict1 = [video1 dictionaryWithValuesForKeys:@[@"videoName",@"size",@"author",@"_isYellow"]];
    NSData *data3 = [NSJSONSerialization dataWithJSONObject:dict1 options:0 error:NULL];
    NSLog(@"%@", dict1);
    
    // 5. 自定义对象的数组进行JSON序列化
    HMVideo *video2 = [[HMVideo alloc] init];
    video2.videoName = @"ll-002.avi";
    video2.size = 502;
    video2.author = @"mazaiting";
    // KVC给成员变量赋值
    [video2 setValue:@(NO) forKey:@"_isYellow"];
    
    HMVideo *video3 = [[HMVideo alloc] init];
    video3.videoName = @"ll-003.avi";
    video3.size = 503;
    video3.author = @"mazaiting";
    // KVC给成员变量赋值
    [video3 setValue:@(YES) forKey:@"_isYellow"];
    
    NSArray *array1 = @[video2, video3];
    
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:2];
    for (HMVideo *video in array1) {
        NSDictionary *dict = [video dictionaryWithValuesForKeys:@[@"videoName",@"size",@"author",@"_isYellow"]];
        [mArray addObject:dict];
    }
    NSData *data4 = [NSJSONSerialization dataWithJSONObject:mArray options:0 error:NULL];
    
    
    return data4;
}

// 解析JSON
- (void)resolveJSON {
    // 把JSON数据保存到本地文件
    NSDictionary *dict = @{@"name":@"zhangsan", @"age":@(18)};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    [data writeToFile:@"/Users/mazaiting/Desktop/111.json" atomically:YES];
    
    // 从本地文件读取JSON数据
    NSData *data1 = [NSData dataWithContentsOfFile:@"/Users/mazaiting/Desktop/111.json"];
    id json = [NSJSONSerialization JSONObjectWithData:data1 options:0 error:NULL];
    NSLog(@"%@", json);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 向服务器发送JSON数据
//    [self postJSON];
    
    // JSON反序列化
    [self resolveJSON];
}

- (void)postJSON {
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/php/upload/postjson.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"post";
    request.HTTPBody = [self createJSON];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
         if (connectionError) {
             NSLog(@"连接错误 %@", connectionError);
             return;
         }
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if (httpResponse.statusCode == 200 || httpResponse.statusCode == 304) {
             // 解析数据
             NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"%@", str);
         } else {
             NSLog(@"服务器内部错误");
         }
     }];
}





@end















