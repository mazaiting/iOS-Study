//
//  ViewController.m
//  01MapView
//
//  Created by mazaiting on 18/1/19.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *mgr;
@end

@implementation ViewController

- (void)viewDidLoad {
    // 1. 创建CLLocationManager
    self.mgr = [CLLocationManager new];
    // 2. 请求用户授权，还需配置Plist
    if ([self.mgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.mgr requestWhenInUseAuthorization];
    }
    // 3. 设置代理
    self.mgr.delegate = self;
    // 4. 调用开始方法定位
    [self.mgr startUpdatingLocation];
}

#pragma mark 代理方法
// 当完成位置更新的时候调用，会频繁调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // 获取位置信息
    CLLocation *location = locations.lastObject;
    NSLog(@"locations: %@", location);
    // 5. 停止定位
    [self.mgr stopUpdatingLocation];
    // locations: <+37.78583400,-122.40641700> +/- 5.00m (speed -1.00 mps / course -1.00) @ 1/19/18, 3:19:43 PM China Standard Time
}

@end
