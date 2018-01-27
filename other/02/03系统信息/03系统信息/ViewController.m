//
//  ViewController.m
//  03系统信息
//
//  Created by mazaiting on 18/1/23.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import "SystemServices.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"All System Information: %@", [SystemServices sharedServices].allSystemInformation);
}

@end
