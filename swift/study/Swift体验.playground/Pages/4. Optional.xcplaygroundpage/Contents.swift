//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

// Optional 可选的，可以有值，可以有为nil
// init? 说明可能无法实例化url
let url = NSURL(string: "http://www.baidu.com/中文")
// !的意思 强行解包， 一旦程序崩溃，就会停在此处
// 程序提示让程序员思考， 代码的安全性更好
//let request = NSURLRequest(URL: url!)

// 更安全的写法
if nil != url {
    let request = NSURLRequest(URL: url!)
}

// 提示： 可选项
// 1. 利用Xcode提示
// 2. 多思考

// if let 判断并且设置数值
if let myUrl = url {
    // 确保myUrl一定有值
    print(myUrl)
}

var oName: String? = "张三"
var oAge: Int? = 18
// 多值之间使用逗号分隔
if let name = oName, age = oAge {
    print(name + String(age))
}


// ?? 操作符
// 如果oName为nil，cName就等于后面的数值，否则使用oName的字符串
let cName = oName ?? "abc"

// 定义列表
var dataList: [String]?

let count = dataList?.count ?? 0
// 为列表赋值
dataList = ["zhangsan", "lisi"]

let count1 = dataList?.count ?? 0








//: [Next](@next)
