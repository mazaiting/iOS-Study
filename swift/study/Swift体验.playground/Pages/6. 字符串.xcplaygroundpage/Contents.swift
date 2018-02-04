//: [Previous](@previous)

import Foundation
import UIKit

var str0 = "Hello, playground"

/*
    String 结构体，效率比对象高
        支持遍历
    NSString 继承NSObject，一般推荐使用String
        不支持遍历
*/

var str: String = "你好世界"

// String支持遍历
for c in str.characters {
    print(c)
}

// 字符串拼接
let name = "老王"
let age = 80
let title = "小菜"
let rect = CGRect(x: 0, y: 0, width: 100, height: 100)

print(name + String(age) + title)
// \(变量名) 就会自动转换拼接
print("\(name)\(age)\(title)\(rect)")


// 拼接字符串小陷阱
let name1:String? = "老王"
print(name1! + String(age) + title)
// 如果是可选项的转换，会带上`Optional`，提示开发人员，值是可选的
print("\(name1)\(age)\(title)\(rect)")

// 真的需要格式
let h = 9
let m = 5
let s = 8

let timeStr = "\(h):\(m):\(s)"
// 注意：参数以数组的形式输入
let timeStr1 = String(format: "%02d:%02d:%02d", arguments: [h,m,s])

// 在Swift中 语言变迁， `Range`，最好把String转换为NSString 
var string = "你好世界"
//string.substringWithRange(aRange: Range<Index>)
(string as NSString).substringWithRange(NSMakeRange(2, 2))
// 遇到简单的取值
string.substringFromIndex("你".endIndex)


















//: [Next](@next)
