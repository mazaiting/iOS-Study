//
//  ViewController.m
//  05MapView使用
//
//  Created by mazaiting on 18/1/19.
//  Copyright © 2018年 mazaiting. All rights reserved.
//
/**
 #pragma mark 1. 显示用户位置
 #pragma mark 2. 设置地图显示类型
 #pragma mark 3. 根据用户位置显示对应的大头针信息
 #pragma mark 4. 设置以用户所在位置为中心点
 #pragma mark 5. 获取地图显示区域改变时的中心点坐标及显示跨度
 */
#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController () <MKMapViewDelegate>
@property (nonatomic, strong) CLLocationManager *mgr;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mgr = [CLLocationManager new];
    if ([self.mgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.mgr requestWhenInUseAuthorization];
    }
//    
//    MKUserTrackingModeNone
//    MKUserTrackingModeFollow 定位
//    MKUserTrackingModeFollowWithHeading 定位并显示方向
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.delegate = self;
}

#pragma mark 改变地图类型
- (IBAction)mapTypeChangeClick:(UISegmentedControl *)sender {
//    MKMapTypeStandard = 0, 默认
//    MKMapTypeSatellite, 卫星
//    MKMapTypeHybrid, 混合
//    MKMapTypeSatelliteFlyover NS_ENUM_AVAILABLE(10_11, 9_0),
//    MKMapTypeHybridFlyover NS_ENUM_AVAILABLE(10_11, 9_0),
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 3:
            self.mapView.mapType = MKMapTypeSatelliteFlyover;
            break;
        case 4:
            self.mapView.mapType = MKMapTypeHybridFlyover;
            break;
        default:
            break;
    }
    
}

#pragma mark 代理方法
//CLLocation *location = locations.lastObject;
//NSLog(@"latitude: %f, longitude: %f", location.coordinate.latitude, location.coordinate.longitude);
@end



















