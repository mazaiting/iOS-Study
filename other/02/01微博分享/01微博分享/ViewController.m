//
//  ViewController.m
//  01微博分享
//
//  Created by mazaiting on 18/1/22.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>

@interface ViewController ()

@end

@implementation ViewController
// 触摸屏幕分享
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 1. 判断系统服务是否可用
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        NSLog(@"请先到设置中打开新浪微博并配置账号");
        return;
    }
    
    // 2. 创建分享控制器
    SLComposeViewController *compose = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    // 2.1 设置文字
    [compose setInitialText:@"世界上一共有10种人，一种是懂二进制的，一种是不懂二进制的."];
    // 2.2 设置图片
    [compose addImage:[UIImage imageNamed:@"qq"]];
    // 2.3 设置网址
    [compose addURL:[NSURL URLWithString:@"https://www.jianshu.com/u/5d2cb4bfeb15"]];
    
    // 3. 模态弹出
    [self presentViewController:compose animated:YES completion:nil];
}

@end
