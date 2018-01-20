//
//  ViewController.m
//  02DOM解析XML
//
//  Created by mazaiting on 18/1/5.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import "GDataXMLNode.h"
#import "Video.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadXML];
}

- (void)loadXML {
    
    NSURL *url = [NSURL URLWithString:@"https://mazaiting.github.io/videos.xml"];
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
             
             // 1. 加载xml文档
             GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data error:NULL];
             
             // 2. 获取xml文档的根元素
             GDataXMLElement *rootElement = document.rootElement;
             
             // 创建可变数组保存对象
             NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
             
             // 3. 遍历所有节点
             for (GDataXMLElement *element in rootElement.children) {
                 // 创建对象
                 Video *v = [[Video alloc] init];
                 // 4. 把对象加入数组中
                 [array addObject:v];
                 
                 // 5. 给对象的属性赋值
                 for (GDataXMLElement *subElement in element.children) {
                     [v setValue:subElement.stringValue forKey:subElement.name];
                 }
                 
                 // 6. 遍历video的所有属性
                 for (GDataXMLNode *attr in element.attributes) {
                     [v setValue:attr.stringValue forKey:attr.name];
                 }
                 
             }
             
             NSLog(@"%@", array);
             
             
         } else {
             NSLog(@"服务器内部错误");
         }
     }];
}

@end
