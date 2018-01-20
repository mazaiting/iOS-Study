//
//  ViewController.m
//  01Sax解析XML
//
//  Created by mazaiting on 18/1/5.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import "Video.h"

@interface ViewController () <NSXMLParserDelegate>
// 保存XML数据
@property (nonatomic, strong) NSMutableArray *videos;
// 当前创建的video对象
@property (nonatomic, strong) Video *video;
// 保存当前节点内容
@property (nonatomic, copy) NSMutableString *string;
@end

@implementation ViewController

// 懒加载
- (NSMutableArray *)videos {
    if (_videos == nil) {
        _videos = [NSMutableArray arrayWithCapacity:10];
    }
    return _videos;
}

- (NSMutableString *)string {
    if (_string == nil) {
        _string = [NSMutableString string];
    }
    return _string;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadXML];
    
}

// 加载XML
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
             NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
             // 设置代理
             parser.delegate = self;
             // 开始执行代理方法
             [parser parse];
             
         } else {
             NSLog(@"服务器内部错误");
         }
     }];

}

// 1. 开始解析文档
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"1开始解析");
}

// 2. 找开始节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    NSLog(@"2找开始节点 %@--%@", elementName, attributeDict);
    
    // 如果是video标签，创建video对象
    if ([elementName isEqualToString:@"video"]) {
        self.video = [[Video alloc] init];
        self.video.videoId = @([attributeDict[@"videoId"] intValue]);
        // 添加到数组中
        [self.videos addObject:self.video];
    }
}

// 3. 找节点之间的内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSLog(@"3找节点之间的内容 %@", string);
    [self.string appendString:string];
}

// 4. 找结束节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSLog(@"4找结束节点 %@", elementName);
    // 判断标签是否有对应的属性
    if (![elementName isEqualToString:@"video"] && ![elementName isEqualToString:@"videos"]) {
        // 为节点赋值
        [self.video setValue:self.string forKey:elementName];
    }
    // 清空字符串
    [self.string setString:@""];
}

// 5. 结束解析文档
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"5结束解析");
    NSLog(@"%@", self.videos);
}

// 6. 解析出错
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"解析出错");
}



@end

























