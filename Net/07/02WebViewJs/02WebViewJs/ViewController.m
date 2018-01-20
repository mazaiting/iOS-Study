//
//  ViewController.m
//  02WebViewJs
//
//  Created by mazaiting on 18/1/18.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation ViewController

- (void)loadView {
    self.webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.backgroundColor = [UIColor whiteColor];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
    
    // 设置代理
    self.webView.delegate = self;
}

#pragma mark 代理方法
// 等待网页加载完成 才能执行js
- (void)webViewDidFinishLoad:(UIWebView *)webView {
//  网页中最后最后一句执行的JavaScript代码  game.chessboard.drawPlanes();
//    [webView stringByEvaluatingJavaScriptFromString:@"game.chessboard.drawPlanes();"];
    // 调用网页中的函数
    NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"test();"];
    NSLog(@"----%@", string);
}

// 发送请求之前， JS调用OC代码
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // 获取url中的协议
    NSLog(@"%@", request.URL.scheme);
    
    // 判断协议是否是自定义协议
    if ([request.URL.scheme isEqualToString:@"source"]) {
        NSLog(@"%@", request.URL.pathComponents);
        // 获取方法名
        NSString *methodName = request.URL.pathComponents[1];
        // 获取参数
        NSString *param = request.URL.pathComponents[2];
        
        // 调用方法
        // 把字符串的方法名称转换为一个selector
        SEL method = NSSelectorFromString(methodName);
        if ([self respondsToSelector:method]) {
            // 解决执行方法的内存泄漏问题
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            // 调用放法
            [self performSelector: method withObject:param];
            #pragma mark diagnostic pop
        }
    }
    // 返回NO，所有的请求都不执行
    return YES;
}

// 显示对话框
- (void)showMessage:(NSString *)str {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    // 弹出的按钮
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"clicker");
    }];
    [vc addAction:action];
    
    [self presentViewController:vc animated:YES completion:nil];
}



@end





















