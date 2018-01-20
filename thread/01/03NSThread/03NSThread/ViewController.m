//
//  ViewController.m
//  03NSThread
//
//  Created by mazaiting on 18/1/18.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self createThread];
}

- (void)createThread {
    // 方式一
    // 创建线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(demo) object:nil];
    // 开启线程
    [thread start];
    
    // 方式二
    [NSThread detachNewThreadSelector:@selector(demo) toTarget:self withObject:nil];
    
    // 方式三
    [self performSelectorInBackground:@selector(demo) withObject:nil];
    
    // 方式4 带参数
    NSThread *threadParam = [[NSThread alloc] initWithTarget:self selector:@selector(demo1:) object:@"mazaiting"];
    [threadParam start];
}

- (void)demo1:(NSString *)name {
    NSLog(@"%@", name);
}

- (void)demo {
    // 打印当前线程
    NSLog(@"hello %@", [NSThread currentThread]);
}

@end
