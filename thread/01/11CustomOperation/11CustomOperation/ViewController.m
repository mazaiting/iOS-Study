//
//  ViewController.m
//  11CustomOperation
//
//  Created by mazaiting on 18/1/18.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import "CustomOperation.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CustomOperation *co = [[CustomOperation alloc] init];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:co];
}
@end
