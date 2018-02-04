//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

/*
    1. 值可以是任何类型
    2. 作用域仅在case内部
    3. 不需要break
    4. 每一个case都需要代码
*/

let name = "老王"

switch name {
    case "老王":
        let age = 80
        print("hi \(age)")
    // 多值的情况
    case "老李", "老方":
        print("朋友")
    default:
        print("other")
}



























//: [Next](@next)
