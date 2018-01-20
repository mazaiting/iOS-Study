//
//  ViewController.m
//  01Downloader
//
//  Created by mazaiting on 18/1/8.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import "MTDownloader.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    MTDownloader *downloader = [MTDownloader new];
    NSString *url = @"http://127.0.0.1/HBuilder.zip";
    [downloader download:url successBlock:^(NSString *path) {
        NSLog(@"下载成功");
    } processBlock:^(float process) {
        NSLog(@"下载进度: %f", process);
    } errorBlock:^(NSError *error) {
        NSLog(@"下载出错 %@", error);
    }];
}

@end
