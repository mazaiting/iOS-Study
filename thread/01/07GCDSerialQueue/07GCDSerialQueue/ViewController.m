//
//  ViewController.m
//  07GCDSerialQueue
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

// 串行队列，同步执行  不开新线程，任务是顺序执行的
- (void)sync {
    dispatch_queue_t queue = dispatch_queue_create("mazaiting", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i < 10; i++) {
        dispatch_sync(queue, ^{
            NSLog(@"%d---%@", i, [NSThread currentThread]);
        });
    }
}

// 串行队列，异步执行  开新线程(1个)，任务是有序执行的
- (void)async {
    dispatch_queue_t queue = dispatch_queue_create("mazaiting", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%d---%@", i, [NSThread currentThread]);
        });
    }
}


@end






















