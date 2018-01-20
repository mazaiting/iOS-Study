//
//  ViewController.m
//  06GCD
//
//  Created by mazaiting on 18/1/18.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 1. 创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 2. 创建任务
    dispatch_block_t task = ^ {
        NSLog(@"hello %@",[NSThread currentThread]);
    };
    // 3. 异步执行
    dispatch_async(queue, task);
    
    // 简化用法
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"mazaiting %@", [NSThread currentThread]);
        // 回到主线程
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"----%@", [NSThread mainThread]);
        });
    });
}

@end
