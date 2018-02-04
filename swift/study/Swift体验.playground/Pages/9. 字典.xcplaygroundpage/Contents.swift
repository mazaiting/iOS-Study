//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

// 定义字典 [String: Object] 
// [key:value]
// key 通常是字符串
// value 可以是任意类型
// 不可变
let dict1 = ["name":"zhangsan", "age":18]
// 可变
var dict = ["name":"zhangsan", "age":18]

// 可变 var & 不可变 let
// 不可变，赋值报错
//dict1["height"] = 1.5
// 可变，赋值正常
dict["height"] = 1.5
// 给字典赋值的时候，如果key已经存在，会覆盖，如果不存在，则创建
dict["name"] = "list"

// 遍历
for (k, v) in dict {
    print("key \(k) value \(v)")
}

// 合并
let dict2 = ["title":"老板", "name":"老王"];
// 遍历
for (k,v) in dict2 {
    // 依次设置dict的内容
    dict[k] = v
}

dict






















//: [Next](@next)
