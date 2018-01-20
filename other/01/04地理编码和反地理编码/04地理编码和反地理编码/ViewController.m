//
//  ViewController.m
//  04地理编码和反地理编码
//
//  Created by mazaiting on 18/1/19.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self encode];
    [self decode];
}

// 地理编码
- (void)encode {
    // 1. 创建一个CLGeocoder对象
    CLGeocoder *geocoder = [CLGeocoder new];
    // 2. 实现地理编码
    [geocoder geocodeAddressString:@"乌鲁木齐" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        // 处理出错
        if (error || placemarks.count == 0) {
            NSLog(@"解析出错");
            return;
        }
        // 遍历数组
        for (CLPlacemark *placeMark in placemarks) {
            NSLog(@"latitude: %f", placeMark.location.coordinate.latitude);
            NSLog(@"longitude: %f", placeMark.location.coordinate.longitude);
            NSLog(@"name: %@", placeMark.name);
//            latitude: 43.792818
//            longitude: 87.617733
//            name: Xinjiang Urumqi
        }
    }];
}

// 反地理编码
- (void)decode {
    // 1. 创建CLGeocoder对象
    CLGeocoder *geocoder = [CLGeocoder new];
    // 2. 创建一个CLLocation对象
    CLLocation *location = [[CLLocation alloc] initWithLatitude:43.792818 longitude:87.617733];
    // 3. 反地理编码
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        // 处理出错
        if (error || placemarks.count == 0) {
            NSLog(@"解析出错");
            return;
        }
        // 遍历数组
        for (CLPlacemark *placeMark in placemarks) {
            NSLog(@"latitude: %f", placeMark.location.coordinate.latitude);
            NSLog(@"longitude: %f", placeMark.location.coordinate.longitude);
            NSLog(@"name: %@", placeMark.name);
//            latitude: 43.794040
//            longitude: 87.620584
//            name: No.37 Zhongshan Road
        }
    }];

}

@end
