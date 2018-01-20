//
//  ViewController.m
//  03临时授权
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
    [super viewDidLoad];
    self.mgr = [CLLocationManager new];
    // 请求定位权限，还需配置Plist，配置键为NSLocationWhenInUseUsageDescription，值为提示用户的信息
    if ([self.mgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.mgr requestWhenInUseAuthorization];
    }
    
    // 请求临时授权, 先判断iOS系统版本。需要配置plist，新增UIBackgroundModes键，增加后时一个数组，然后第一项名字设置为"App registers for location updates"
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        // 变现为应用程序进入后台时可以继续更新当前位置
        self.mgr.allowsBackgroundLocationUpdates = YES;
    }
    self.mgr.delegate = self;
    [self.mgr startUpdatingLocation];
    
    // 计算两点之间的位置
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:40 longitude:116];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:34.27 longitude:108.93];
    // 比较的是直线距离
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
    NSLog(@"distance: %f", distance);
    
}

#pragma mark 代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    NSLog(@"latitude: %f, longitude: %f", location.coordinate.latitude, location.coordinate.longitude);
}

@end
