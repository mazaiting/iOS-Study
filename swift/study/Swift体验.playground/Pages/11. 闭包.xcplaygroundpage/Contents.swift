//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

// 可以理解为OC中的block
/*
    1. 一组预先准备好的代码
    2. 可以当做参数传递
    3. 在需要的时候执行

    OC中的block类似于匿名函数
*/

// 定义
func sum(num1 x: Int,num2 y: Int) -> Int {
    return x + y;
}
//sum(10, y: 20)
sum(num1: 10, num2: 20)


//----------以下两行仅供体验
// 在Swift中，可以变量可以直接记录函数
let sumFunc = sum
// 执行函数
sumFunc(num1: 5, num2: 6)


// 闭包的定义
/*
    1. 形参，返回值，代码都包含在{}中
*/

// 最简单的闭包，如果没有参数，没有返回值，通通可以省略
let demoFunc = {
    print("Hello world")
}
// 执行闭包
demoFunc()

// in 就是区分函数定义和代码实现
// 格式： { (带外部参数的形参列表} -> 返回类型 in 代码实现 }
let demoFunc2 = { (num1 x: Int,num2 y: Int) -> Int in
    return x + y;
}
demoFunc2(num1: 10, num2: 20)


// -- 分类
// 尾随闭包
// 1. 闭包是最后一个参数
// 2. 函数的()可以提前关闭
// 3. 最后一个参数直接可以使用{ 代码实现 }
dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
    print("尾随闭包")
}
dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
    print("非尾随闭包")
})


// 通过block 回调异步代码的结果
func loadData() {
    dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
        print("玩命加载中...")
        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
            print("主线程回调")
        })
    }
}

func loadData1(finished: (msg: String)->()) {
    dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
        print("玩命加载中...")
        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
            // 通过闭包回调结果,执行完成回调函数
            print("主线程回调")
            finished(msg: "OK")
        })
    }
}

loadData1 { (msg) -> () in
    print("主线程over \(msg)")
};


// 解决循环引用
// 写法一
// weak 弱引用特点：
// 1. 不会强引用
// 2. 指向地址的对象一旦被释放，弱引用地址会自动设置为nil
//loadData{ [weak self] (msg) -> in
//    print(msg+ "\(self?.view)")
//}
//
//// 写法二
//// 会记录self的地址，不进行强引用
//// 风险： 一旦self真的被释放了，程序就会崩溃
//loadData{ [unowned self] (msg) -> in
//    print(msg+ "\(self.view)")
//}

















//: [Next](@next)
