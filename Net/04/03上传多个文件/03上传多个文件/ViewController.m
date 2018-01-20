//
//  ViewController.m
//  03上传多个文件
//
//  Created by mazaiting on 18/1/7.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#define kBOUNDARY @"abc"
- (void)viewDidLoad {
    [super viewDidLoad];
    // 网络链接
    NSString *netUrl = @"http://127.0.0.1/php/upload/upload-m.php";
    
    // 文件路径
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"head1.png" ofType:nil];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"head2.png" ofType:nil];
    NSArray *array = @[path1, path2];
    
    // 字段名
    NSString *fieldName = @"userfile[]";
    // 数据字典
    NSDictionary *dict = @{@"username":@"mazaiting"};
    // 上传文件
    [self uploadFiles:netUrl fieldName:fieldName filePaths:array params:dict];
    
}

// 上传多个文件
// netUrl 网络链接
// fieldName 字段名
// filePaths 文件路径数组
// params 参数字典
- (void)uploadFiles:(NSString *)netUrl fieldName:(NSString *)fieldName filePaths:(NSArray *)filePaths params:(NSDictionary *)params {
    NSURL *url = [NSURL URLWithString:netUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"post";
    // Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryJa8BALfIc9saou2X
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBOUNDARY] forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [self body:fieldName filePaths:filePaths params:params];
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
             NSLog(@"%@",dict);
         } else {
             NSLog(@"服务器内部错误");
         }
     }];
}

// 构建请求体
- (NSData *)body:(NSString *)fieldName filePaths:(NSArray *)filePaths params:(NSDictionary *)params {
    NSMutableData *mData = [NSMutableData data];
//    ------WebKitFormBoundaryJa8BALfIc9saou2X
//    Content-Disposition: form-data; name="userfile[]"; filename="head1.png"
//    Content-Type: image/png
//    
//    文件二进制数据
//    ------WebKitFormBoundaryJa8BALfIc9saou2X
//    Content-Disposition: form-data; name="userfile[]"; filename="head2.png"
//    Content-Type: image/png
//    
//    文件二进制数据
//    ------WebKitFormBoundaryJa8BALfIc9saou2X
//    Content-Disposition: form-data; name="username"
//    
//    mazaiting
//    ------WebKitFormBoundaryJa8BALfIc9saou2X--
    
    // 构建文件,遍历数组
    [filePaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//              ------WebKitFormBoundaryJa8BALfIc9saou2X
//            Content-Disposition: form-data; name="userfile[]"; filename="head2.png"
//            Content-Type: image/png
//        
//            文件二进制数据
        
        NSMutableString *mString = [NSMutableString string];
        // 判断是否是第一个文件，如果是则不需要添加"\r\n"
        if (idx != 0) {
            [mString appendString:@"\r\n"];
        }
        [mString appendFormat:@"--%@\r\n", kBOUNDARY];
        [mString appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n", fieldName, [obj lastPathComponent]];
        [mString appendString:@"Content-Type: application/octet-stream\r\n"];
        [mString appendString:@"\r\n"];
        [mData appendData:[mString dataUsingEncoding:NSUTF8StringEncoding]];
        // 拼接文件的二进制数据
        NSData *data = [NSData dataWithContentsOfFile:obj];
        [mData appendData:data];
    }];
    
    // 构建数据
    //    ------WebKitFormBoundaryJa8BALfIc9saou2X
    //    Content-Disposition: form-data; name="username"
    //
    //    mazaiting
    //    ------WebKitFormBoundaryJa8BALfIc9saou2X--
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableString *mString = [NSMutableString string];
        [mString appendFormat:@"\r\n--%@\r\n", kBOUNDARY];
        [mString appendFormat:@"Content-Disposition: form-data; name=%@\r\n", key];
        [mString appendString:@"\r\n"];
        [mString appendFormat:@"%@", obj];
        [mData appendData:[mString dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // 结束语句
    NSString *end = [NSString stringWithFormat:@"\r\n--%@--", kBOUNDARY];
    [mData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];

    return mData.copy;
}






@end

















