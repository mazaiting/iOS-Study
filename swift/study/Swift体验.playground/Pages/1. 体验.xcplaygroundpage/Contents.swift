//: Playground - noun: a place where people can play

import UIKit

// 1. 不需要项目
// 2. 直接写代码，右侧预览
// 3. 学习语言，测试代码

var str = "Hello, playground"

// 创建对象
let v = UIView(frame: CGRectMake(0, 0, 100, 100))

// 设置颜色
v.backgroundColor = UIColor.redColor()

// 创建按钮
let btn = UIButton(type: UIButtonType.ContactAdd)

// 将按钮添加到视图
btn.center = v.center
v.addSubview(btn)

