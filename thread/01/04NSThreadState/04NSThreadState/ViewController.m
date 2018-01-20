//
//  ViewController.m
//  04NSThreadState
//
//  Created by mazaiting on 18/1/18.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, copy) NSString *name;
@end

@implementation ViewController
// 为属性生成对应的成员变量
@synthesize name = _name;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 新建状态
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(demo) object:nil];
    // 就绪状态
    [thread start];
    [self demo1];
}

- (void)demo1 {
    // 互斥锁
    @synchronized(self) {
        NSLog(@"%@",self);
    }
}

- (void)demo {
    for (int i = 0; i < 20; i++) {
        NSLog(@"%d", i);
        if (i == 5) {
            // 阻塞状态 -- 睡眠3秒
            [NSThread sleepForTimeInterval:3];
        }
        if (i == 10) {
            // 线程退出 -- 死亡状态
            [NSThread exit];
        }
    }
}

@end
