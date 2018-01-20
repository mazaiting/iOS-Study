//
//  ViewController.m
//  01pthread
//
//  Created by mazaiting on 18/1/18.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import <pthread/pthread.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 创建子线程，线程编号
    pthread_t pthread;
    // 第一个参数 线程编号的地址
    // 第二个参数 线程的属性
    // 第三个参数 线程的要执行的函数
    // 第四个参数 要执行的函数的参数
    // 返回值 int 0是成功 非0是失败
    int result = pthread_create(&pthread, NULL, demo, NULL);
    NSLog(@"touchesBegan %@", [NSThread currentThread]);
    
    if (result) {
        NSLog(@"失败");
    } else {
        NSLog(@"成功");
    }
}

// 函数必须是C语言的
void *demo(void *param) {
    NSLog(@"hello %@", [NSThread currentThread]);
    return NULL;
}

@end
