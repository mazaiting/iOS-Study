//
//  ViewController.m
//  08GCDConcurrentQueue
//
//  Created by mazaiting on 18/1/18.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self sync];
    [self async];
}

// 并行队列，同步执行 --- 串行队列，同步执行，不开线程，顺序执行
- (void)sync {
    dispatch_queue_t queue = dispatch_queue_create("mazaiting", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 10; i++) {
        dispatch_sync(queue, ^{
            NSLog(@"%d---%@", i, [NSThread currentThread]);
        });
    }
}

// 并行队列，异步执行 --- 开多个线程，无序执行
- (void)async {
    dispatch_queue_t queue = dispatch_queue_create("mazaiting", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%d---%@", i, [NSThread currentThread]);
        });
    }
}

@end










