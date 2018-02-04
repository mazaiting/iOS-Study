//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

// 定义函数
// 格式： fun 函数名(形参列表) -> 返回值类型{ // 代码实现 }
func sum(x: Int, y: Int) ->Int {
    return x + y;
}

// 调用函数 函数名(值1, 参数名: 值2)
sum(10, y: 20);

// 外部参数, 供外部调用的程序员参考的，保证函数的语义更加清晰
// 内部参数, x y, 数据函数内部使用
func sum1(num1 x: Int, num2 y: Int) ->Int {
    return x + y;
}

sum1(num1: 3, num2: 8)


// 返回值 `->`

// 没有返回值
// 1. 直接省略
func demo() {
    print("haha")
}
demo()
// 2. 使用Void
func demo1() -> Void {
    print("hehe")
}
demo1()
// 3. -> ()
func demo2() -> () {
    print("lala")
}
demo2()






















//: [Next](@next)
