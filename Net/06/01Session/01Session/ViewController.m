//
//  ViewController.m
//  01Session
//
//  Created by mazaiting on 18/1/9.
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

// post请求
- (void)post {
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/demo.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"post";
    request.HTTPBody = [@"username=123&password=123" dataUsingEncoding:NSUTF8StringEncoding];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@", dict);
    }] resume];
    
}

// get请求
- (void)get {
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/demo.json"];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@", dict);
    }] resume];
}
@end
