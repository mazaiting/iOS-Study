//: [Previous](@previous)

import Foundation
import UIKit

var str = "Hello, playground"

// 创建数组, [String]代表存放字符串的数组
let array = ["zhangsan", "lisi"]
// 遍历数组
for name in array {
    print(name)
}
// 创建一个任何类型的数组， 类型不一致，自动推到为[NSObject]
let array1 = ["zhangsan", 18, UIView()]
for name in array1 {
    print(name)
}

// 可变和不可变 可变是var 不可变是let
var list = ["zhangsan", "lisi"]
// 追加元素
list.append("wangwu")


// 删除
//list.removeFirst()
//list.removeLast()
//list
//list.removeAtIndex(1)
//list
//list.removeAll()
//list
print(list.capacity)
list.removeAll(keepCapacity: true)
print(list.capacity)

// 数组容量的调试
// 1. 定义并且实例化一个只能保存字符串的数组
var arrayM = [String]()
// 2. 追加数组
// 跟踪发现，如果数组的容量不够，再添加元素的时候，会在当前容量上*2
for i in 0..<16 {
    arrayM.append("hello \(i)")
    print("索引:\(i),数组容量: \(arrayM.capacity)")
}

// 定义数组，并且指定容量,并且实例化对象
var arrayM2 = [Int]()
// 定义数组，指定数组能够保存整数，并未初始化，无法向数组添加对象
var arrayM3: [Int]
// 初始化数组
arrayM3 = [Int]()

// 定义数组指定容量
// count是数组容量，repeatedValue填充数组的初始值
var arrayM4 = [Int](count: 32, repeatedValue: 0)


// 数组的拼接
var arr1 = [1,2,3,4,5,6]
var arr2 = [7,8,9,10]
var arr3 = arr1 + arr2
//或者
arr1 += arr2

// 注意：数组拼接的时候，数组的类型必须是一致的

















//: [Next](@next)
