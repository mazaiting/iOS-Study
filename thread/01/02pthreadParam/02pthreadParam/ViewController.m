//
//  ViewController.m
//  02pthreadParam
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
    // 创建子线程， 线程编号
    pthread_t pthread;
    char *nameC = "mazaiting";
    int result = pthread_create(&pthread, NULL, demo, (void *)nameC);
    if (result) {
        NSLog(@"失败");
    } else {
        NSLog(@"成功");
    }
    NSString *nameNS = @"zaitingma";
    // 传参时要将OC中的对象传递给C语言的函数，要使用桥接， __bridge
    int result1 = pthread_create(&pthread, NULL, demo1, (__bridge void *)nameNS);
    if (result1) {
        NSLog(@"失败");
    } else {
        NSLog(@"成功");
    }
}

void *demo1(void *param) {
    NSString *string = (__bridge NSString *)param;
    NSLog(@"%@", string);
    return NULL;
}

void *demo(void *param) {
    char *string = param;
    NSLog(@"%s", string);
    return NULL;
}

@end
