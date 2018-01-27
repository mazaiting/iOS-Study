//
//  ViewController.h
//  Mac服务器
//
//  Created by mazaiting on 18/1/27.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GCDAsyncSocket.h"

@interface ViewController : NSViewController

// 设置一个服务器
@property (nonatomic, strong) GCDAsyncSocket *server;

@end

