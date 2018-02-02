//
//  MTUpdateTableViewController.m
//  XMPP
//
//  Created by mazaiting on 18/2/1.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "MTUpdateTableViewController.h"

@interface MTUpdateTableViewController ()
// 信息输入框
@property (weak, nonatomic) IBOutlet UITextField *textMessage;
// 内存存储
@property (nonatomic, strong) XMPPvCardTemp *myvCardTemp;
@end

@implementation MTUpdateTableViewController

// 懒加载
- (XMPPvCardTemp *)myvCardTemp {
    if (nil == _myvCardTemp) {
        _myvCardTemp = [MTStreamManager sharedManager].xmppvCardTempModule.myvCardTemp;
    }
    return _myvCardTemp;
}

// 取消按钮
- (IBAction)cancel:(id)sender {
    // 关闭当前控制器
    [self.navigationController popViewControllerAnimated:YES];
}

// 更新数据
- (IBAction)update:(id)sender {
    // 数据更新
    if ([self.title isEqualToString:@"昵称"]) {
        // 对昵称做更新
        self.myvCardTemp.nickname = self.textMessage.text;
    } else {
        // 对个性签名做更新
        self.myvCardTemp.description = self.textMessage.text;
    }
    // 更新数据
    [[MTStreamManager sharedManager].xmppvCardTempModule updateMyvCardTemp:self.myvCardTemp];
    // 关闭当前控制器
    [self.navigationController popViewControllerAnimated:YES];
}

@end
