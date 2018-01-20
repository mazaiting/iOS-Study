//
//  ViewController.m
//  01Downloader
//
//  Created by mazaiting on 18/1/8.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import "MTProcessView.h"
#import "MTDownloadManager.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet MTProcessView *processView;

@end

@implementation ViewController
- (IBAction)download {
    NSString *url = @"http://127.0.0.1/HBuilder.zip";
    [[MTDownloadManager sharedManager] download:url successBlock:^(NSString *path) {
        NSLog(@"下载成功");
    } processBlock:^(float process) {
        self.processView.process = process;
        NSLog(@"下载进度: %f", process);
    } errorBlock:^(NSError *error) {
        NSLog(@"下载出错 %@", error);
    }];
}
- (IBAction)pause {
    NSString *url = @"http://127.0.0.1/HBuilder.zip";
    [[MTDownloadManager sharedManager] pause:url];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
