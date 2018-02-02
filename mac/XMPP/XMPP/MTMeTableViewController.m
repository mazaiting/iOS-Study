//
//  MTMeTableViewController.m
//  XMPP
//
//  Created by mazaiting on 18/2/1.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "MTMeTableViewController.h"

@interface MTMeTableViewController () <XMPPvCardTempModuleDelegate>
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *icon;
// JID
@property (weak, nonatomic) IBOutlet UILabel *name;
// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nickName;
// 个性签名
@property (weak, nonatomic) IBOutlet UILabel *desc;

// 内存存储个人信息
@property (nonatomic, strong) XMPPvCardTemp *myvCardTemp;
@end

@implementation MTMeTableViewController

// 懒加载获取存储数据
- (XMPPvCardTemp *)myvCardTemp {
    if (nil == _myvCardTemp) {
        _myvCardTemp = [MTStreamManager sharedManager].xmppvCardTempModule.myvCardTemp;
    }
    return _myvCardTemp;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置代理,需要更新用户资料的界面都要实现这个代理
    [[MTStreamManager sharedManager].xmppvCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    // 设置参数
    [self update];
}

// 更新
- (void)update {
    // 头像
    self.icon.image = [UIImage imageWithData:self.myvCardTemp.photo];
    // 名字
    self.name.text = [MTStreamManager sharedManager].xmppStream.myJID.bare;
    // 昵称
    self.nickName.text = self.myvCardTemp.nickname;
    // 个性签名
    self.desc.text = self.myvCardTemp.description;
}

// 更新，需要更新用户资料的界面都要实现这个代理
- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule {
    // 清除之前的内存
    self.myvCardTemp = nil;
    // 重新赋值最新的数据
    [self update];
}

@end
