//
//  ViewController.m
//  01WebView
//
//  Created by mazaiting on 18/1/18.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
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
    // 加载网页
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
    // 加载doc
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"面向对象C.doc" withExtension:nil];
    // 加载pdf
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"史提夫乔布斯传.pdf" withExtension:nil];
    // 播放视频
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"qixi.mp4" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    // 自动检测电话号码、网址、邮件地址
    self.webView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
    // 缩放网页
    self.webView.scalesPageToFit = YES;
}


@end
