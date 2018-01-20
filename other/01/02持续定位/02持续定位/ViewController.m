//
//  ViewController.m
//  02持续定位
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
    // 创建CLLocationManager
    self.mgr = [CLLocationManager new];
    // 请求永久权限
    if ([self.mgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.mgr requestAlwaysAuthorization];
    }
    // 设置代理
    self.mgr.delegate = self;
    // 开始定位
    [self.mgr startUpdatingLocation];
    // 设置位置筛选器，节省电量
    self.mgr.distanceFilter = 10;
    // 设置期望精度
    self.mgr.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    // 期望精度可选值
//    kCLLocationAccuracyBest;
//    kCLLocationAccuracyNearestTenMeters;
//    kCLLocationAccuracyHundredMeters;
//    kCLLocationAccuracyKilometer;
//    kCLLocationAccuracyThreeKilometers;
}

#pragma mark 代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    NSLog(@"---%@", location);
}

@end
