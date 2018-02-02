//
//  AppDelegate.m
//  XMPP
//
//  Created by mazaiting on 18/1/29.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 登陆
    [[MTStreamManager sharedManager] loginWithName:@"linghaoyu" andPassword:@"123456"];
    // 需要一个用户通知设置
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound|UIUserNotificationTypeAlert|UIUserNotificationTypeBadge categories:nil];
    // 注册
    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor grayColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    return YES;
}
@end
