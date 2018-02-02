//
//  ViewController.m
//  XMPP
//
//  Created by mazaiting on 18/1/29.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"

#define USERNAME @"username"
#define PASSWORD @"password"
#define MAINVIEW @"MainView"

@interface ViewController ()
// 用户名输入框
@property (weak, nonatomic) IBOutlet UITextField *userName;
// 密码输入框
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@end

@implementation ViewController

- (void)viewDidLoad {
    // 加载用户信息
    [self loadInfo];
}

// 注册
- (IBAction)regist:(id)sender {
    NSString *username = self.userName.text;
    NSString *password = self.passWord.text;
    if (nil == username || [username isEqualToString:@""]) {
        return;
    }
    if (nil == password || [password isEqualToString:@""]) {
        return;
    }
    // 注册
    [[MTStreamManager sharedManager] registWithName:username andPassword:password];
}
// 登陆
- (IBAction)login:(id)sender {
    NSString *username = self.userName.text;
    NSString *password = self.passWord.text;
    if (nil == username || [username isEqualToString:@""]) {
        return;
    }
    if (nil == password || [password isEqualToString:@""]) {
        return;
    }
    // 登陆
    [[MTStreamManager sharedManager] loginWithName:username andPassword:password];
    // 保存
    [self saveWithName:username andPwd:password];
    // 创建新界面
    MainViewController *mVC = [self.storyboard instantiateViewControllerWithIdentifier:MAINVIEW];
    // 开启新界面
    [self presentViewController:mVC animated:YES completion:nil];
}

// 保存用户名和密码
- (void) saveWithName:(NSString *)username andPwd:(NSString *)password {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 保存用户名
    [userDefaults setObject:username forKey:USERNAME];
    // 保存密码
    [SSKeychain setPassword:password forService:[NSBundle mainBundle].bundleIdentifier account:username];
    // 立即保存
    [userDefaults synchronize];
}
// 读取用户名和密码
- (void) loadInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 获取用户名
    NSString *username = [userDefaults objectForKey:USERNAME];
    // 获取密码
    NSString *password = [SSKeychain passwordForService:[NSBundle mainBundle].bundleIdentifier account:username];
    // 给文本框赋值
    self.userName.text = username;
    self.passWord.text = password;
}

@end
