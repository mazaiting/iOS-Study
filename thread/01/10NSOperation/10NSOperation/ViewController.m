//
//  ViewController.m
//  10NSOperation
//
//  Created by mazaiting on 18/1/18.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 1. 调用start执行, 不会开启新线程，start方法更新操作的状态，调用main方法
    // 创建
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(demo) object:nil];
    NSLog(@"--%d", op.isFinished);
    // 开始执行
    [op start];
    NSLog(@"--%d", op.isFinished);
    
    // 2. 添加到队列
    // 创建操作
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(demo) object:nil];
    // 添加到队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 将操作添加到队列
    [queue addOperation:op1];
    
}

- (void)demo {
    NSLog(@"hello %@", [NSThread currentThread]);
}

@end
