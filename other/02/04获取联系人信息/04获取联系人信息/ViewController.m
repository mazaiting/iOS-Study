//
//  ViewController.m
//  04获取联系人信息
//
//  Created by mazaiting on 18/1/23.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import <ContactsUI/ContactsUI.h>

@interface ViewController () <CNContactPickerDelegate>

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 1. 创建控制器
    CNContactPickerViewController *contact = [CNContactPickerViewController new];
    // 2. 设置代理
    contact.delegate = self;
    // 3. 模态弹出
    [self presentViewController:contact animated:YES completion:nil];
}

#pragma mark 选择联系人的时候调用
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    // 1. 获取姓名
    NSLog(@"givenName: %@, familyName: %@", contact.givenName, contact.familyName);
    // 2. 获取电话
    for (CNLabeledValue *labeledValue in contact.phoneNumbers) {
        CNPhoneNumber *phoneNumber = labeledValue.value;
        NSLog(@"phoneNumber: %@", phoneNumber.stringValue);
    }
}

#pragma mark 实现了此方法就可以选择多个联系人
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact *> *)contacts {
    for (CNContact *contact in contacts) {
        
        NSLog(@"givenName: %@, familyName: %@", contact.givenName, contact.familyName);
        for (CNLabeledValue *labeledValue in contact.phoneNumbers) {
            NSLog(@"label: %@", labeledValue.label);
            CNPhoneNumber *phoneNumber = labeledValue.value;
            NSLog(@"phoneNumber: %@", phoneNumber.stringValue);
        }
    }
}
@end
