//: [Previous](@previous)

import Foundation

var str = "Hello, playground"
// 日常开发中，首选let，在必须要改的时候再改
// 自动推导右侧的数值，推导数据类型
//: [Next](@next)
// 定义变量
var x = 20
x = 30

// 定义常量
let y = 30
//y = 30

// 相加
let z = x + y

// 语言严格
// option + click 快捷键查看数据类型
// 整数默认类型是 Int
let num1 = 1
// 小数默认类型是Double
let num2 = 1.5
// 如果要计算必须要转换类型
let num3 = num1 + Int(num2)
let num4 = Double(num1) + num2

// 自己指定变量类型
let i: Double = 10
let j = 1.5
i + j


