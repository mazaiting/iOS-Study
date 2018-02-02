//
//  MTDetailTableViewController.m
//  XMPP
//
//  Created by mazaiting on 18/2/1.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "MTDetailTableViewController.h"

@interface MTDetailTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, XMPPvCardTempModuleDelegate>
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *icon;
// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nickname;
// 个性签名
@property (weak, nonatomic) IBOutlet UILabel *desc;
// 内存缓存
@property (nonatomic, strong) XMPPvCardTemp *xmppvCardTemp;
@end

@implementation MTDetailTableViewController

// 懒加载内存缓存
- (XMPPvCardTemp *)xmppvCardTemp {
    if (nil == _xmppvCardTemp) {
        _xmppvCardTemp = [MTStreamManager sharedManager].xmppvCardTempModule.myvCardTemp;
    }
    return _xmppvCardTemp;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 代理设置
    [[MTStreamManager sharedManager].xmppvCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    // 数据显示
    [self update];
}

// 更新数据
- (void)update {
    // 头像
    self.icon.image = [UIImage imageWithData:self.xmppvCardTemp.photo];
    // 昵称
    self.nickname.text = self.xmppvCardTemp.nickname;
    // 个性签名
    self.desc.text = self.xmppvCardTemp.description;
}

// 选择照片--换头像
- (IBAction)pickerImage:(id)sender {
    // 相册
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    // 参数设置
    picker.allowsEditing = YES;
    // 设置代理
    picker.delegate = self;
    // 弹出控制器
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

// 选中照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"info = %@", info);
    // 获取图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    // 装换为二进制数据
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
    // 内存存储
    self.xmppvCardTemp.photo = imageData;
    // 数据更新
    [[MTStreamManager sharedManager].xmppvCardTempModule updateMyvCardTemp:self.xmppvCardTemp];
    // 销毁控制器
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

// 取消选中
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // 销毁控制器
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

// 更新数据
- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule {
    // 数据重新赋值
    // 1. 清除内存存储
    self.xmppvCardTemp = nil;
    // 2. 重新赋值
    [self update];
}

// 跳转传参数
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"desc"]) {
        segue.destinationViewController.title = @"个性签名";
    } else {
        segue.destinationViewController.title = @"昵称";
    }
}

@end
