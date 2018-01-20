//
//  ViewController.m
//  02上传单个文件
//
//  Created by mazaiting on 18/1/7.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import "SSKeychain.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self uploadFile:@"http://127.0.0.1/php/upload/upload.php" filePath:@"head1.png" fieldName:@"userfile"];
}
#define kBOUNDARY @"abc"
// 上传单个文件
- (void)uploadFile:(NSString *)netUrl filePath:(NSString *)filePath fieldName:(NSString *)fieldName{
    NSURL *url = [NSURL URLWithString:netUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"post";
    // Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryhT0AfwNoY4DpooRu
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", kBOUNDARY] forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [self body:filePath fieldName: fieldName];
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
             NSLog(@"%@", dic);
         } else {
             NSLog(@"服务器内部错误");
         }
     }];
}

- (NSData *)body:(NSString *)filePath fieldName:(NSString *)fieldName{
    NSMutableData *mData = [NSMutableData data];
    
//    ------WebKitFormBoundaryhT0AfwNoY4DpooRu
//    Content-Disposition: form-data; name="userfile"; filename="head1.png"
//    Content-Type: image/png
//    
//    文件的二进制数据
//    ------WebKitFormBoundaryhT0AfwNoY4DpooRu--
    NSMutableString *mString = [NSMutableString string];
    
    [mString appendFormat:@"--%@\r\n", kBOUNDARY];
    [mString appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n", fieldName, [filePath lastPathComponent]];
    [mString appendString:@"Content-Type: application/octet-stream\r\n"];
    [mString appendString:@"\r\n"];
    // 拼接文件二进制之前的数据
    [mData appendData:[mString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:filePath ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    [mData appendData:data];
    
    NSString *end = [NSString stringWithFormat:@"\r\n--%@--", kBOUNDARY];
    [mData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    return mData.copy;
}

@end











