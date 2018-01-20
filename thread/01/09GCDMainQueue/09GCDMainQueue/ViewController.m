//
//  ViewController.m
//  09GCDMainQueue
//
//  Created by mazaiting on 18/1/18.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self demo];
//    [self demo1];
    [self demo2];
}

// 1. 主队列，异步执行 --- 主线程，顺序执行
// 主队列特点：先执行完主线程上的代码，才会执行主队列中的任务
- (void)demo {
    for (int i = 0; i < 10; i++) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"hello %d %@", i, [NSThread currentThread]);
        });
    }
}

// 2. 主队列，同步执行 --- 主线程上执行才会死锁
// 同步执行： 会等着第一个任务执行完成后才会继续往后执行
- (void)demo1 {
    NSLog(@"开始");
    for (int i = 0; i < 10; i++) {
        // 死锁
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"hello %d %@", i, [NSThread currentThread]);
        });
    }
    NSLog(@"结束");
}

// 3. 解决死锁
- (void)demo2 {
    NSLog(@"开始");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < 10; i++) {
            // 死锁
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"hello %d %@", i, [NSThread currentThread]);
            });
        }
    });
    NSLog(@"结束");
}


@end
