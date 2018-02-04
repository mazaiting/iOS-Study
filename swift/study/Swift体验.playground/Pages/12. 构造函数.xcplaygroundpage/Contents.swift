//: [Previous](@previous)

// 在Swift中，默认是所有的类`全局共享`的，不需要做任何的引用，就可以直接使用
// 准备的说是在同一个`命名空间`下全局共享，默认情况下，`命名空间`是项目名称
// 项目名称最好不要用中文名称
import Foundation

var str = "Hello, playground"

// 如果没有实现构造函数，会执行父类的构造函数
class Person: NSObject {
    // 存储型属性`没有设置初始值` -> 在构造函数中设置初始值
    // 姓名
    var name: String
    var age: Int
    
    // 没有func，override 重写父类的构造函数
    // 每一个OC对象， 都继承自NSObject，都有init函数
    override init() {
        name = "张三"
        age = 10
        // 调用父类构造函数，必须放在最后
        super.init()
    }
}


let person = Person()
print("\(person.name) + \(person.age)")

class Student: Person {
    // 学号
    var no: String
    override init() {
        no = "001"
        // 可不写， 默认情况下，系统会自动调用父类的构造函数
        super.init()
    }
}

let student = Student()
print("\(student.name) + \(student.age) + \(student.no)")


// 如果没有实现构造函数，会执行父类的构造函数
class People: NSObject {
    // 可选项，允许为空，在设置数值的时候，临时分配空间
    // 存储型属性`没有设置初始值` -> 在构造函数中设置初始值
    // 姓名--可选型
    var name: String?
    // 默认值为nil--可选型
    var age: Int?
    
    // 如果没有init构造函数，一旦实现了其他的构造函数，就会选择其他的构造函数
    override init() {
        name = "zhangsan"
        age = 10
    }
    
    // 重载，函数名相同，参数不同
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}


let people = People()
print("\(people.name) + \(people.age)")

let people1 = People(name: "mazaiting", age: 18)
print("\(people1.name) + \(people1.age)")


// KVC
// 如果没有实现构造函数，会执行父类的构造函数
class Person1: NSObject {
    // 存储型属性`没有设置初始值` -> 在构造函数中设置初始值
    // 姓名
    var name: String?
    // 默认值是nil，并不会分配内存空间，如果使用KVC设置数值，就会崩溃
    // 注意： 如果要使用KVC给对象设置数值，`基本数据`类型，必须设置初始值
    var age: Int = 0
    
    // 错误信息--the class is not key value coding-compliant for the key `age`
    // 在使用KVC的时候，如果值没有分配内存空间，如果是结构体/类，会先调用默认的构造函数分配内存空间，然后再设置值，如果是基本的数据类型，，就直接崩溃
    init(dict: [String : AnyObject]) {
        super.init()
        // KVC赋值， 在调用之前，必须调用super.init() -> 本类的属性和父类的属性全部被初始化
        setValuesForKeysWithDictionary(dict)
    }
    
    
    /*
        1. setValuesForKeysWithDictionary 会遍历字典中的所有键值对， 一次调用setValue
        2. 系统默认会给各个属性设置数值
        3. 如果没有key对应的属性， 会调用forUndefinedKey方法，过滤掉不需要的属性
        4. 如果没有实现 forUndefinedKey 方法， 会直接崩溃
        5. 如果父类实现了KVC的方法，子类就不需要单独实现
    */
    override func setValue(value: AnyObject?, forKey key: String) {
        print("key -- \(key)")
        
        // 非常重要的调试技巧
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        print("------ \(key)")
    }
}

let person1 = Person1(dict: ["name": "李", "age":29])
print("\(person1.name) + \(person1.age)")


// 便利构造函数
// 如果没有实现构造函数，会执行父类的构造函数
class Person2: NSObject {
    // 存储型属性`没有设置初始值` -> 在构造函数中设置初始值
    // 姓名
    var name: String?
    // 默认值是nil，并不会分配内存空间，如果使用KVC设置数值，就会崩溃
    // 注意： 如果要使用KVC给对象设置数值，`基本数据`类型，必须设置初始值
    var age: Int = 0
    
    // convenience 便利构造函数
    /*
        1. 判断参数条件是否合法
        2. 传递常用参数
        3. 如果条件满足，可以返回nil，只有便利的构造函数才可以返回nil
        4. 指定的构造函数是不允许返回nil的，必须返回一个对象
        5. 指定的构造函数，默认的都是指定的
        6. 只有便利构造函数可以调用super.init()
        7. 子类只能重写指定的构造函数
    */
    convenience init?(name: String, age: Int) {
        // 判读年龄
        if age < 0 || age > 100 {
            return nil
        }
        
        // 调用默认的构造函数设置初始值
        self.init(dict: ["name": name, "age": age])
    }
    
    // 错误信息--the class is not key value coding-compliant for the key `age`
    // 在使用KVC的时候，如果值没有分配内存空间，如果是结构体/类，会先调用默认的构造函数分配内存空间，然后再设置值，如果是基本的数据类型，，就直接崩溃
    init(dict: [String : AnyObject]) {
        super.init()
        // KVC赋值， 在调用之前，必须调用super.init() -> 本类的属性和父类的属性全部被初始化
        setValuesForKeysWithDictionary(dict)
    }
    
    
    /*
    1. setValuesForKeysWithDictionary 会遍历字典中的所有键值对， 一次调用setValue
    2. 系统默认会给各个属性设置数值
    3. 如果没有key对应的属性， 会调用forUndefinedKey方法，过滤掉不需要的属性
    4. 如果没有实现 forUndefinedKey 方法， 会直接崩溃
    5. 如果父类实现了KVC的方法，子类就不需要单独实现
    */
    override func setValue(value: AnyObject?, forKey key: String) {
        print("key -- \(key)")
        
        // 非常重要的调试技巧
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        print("------ \(key)")
    }
}

let person2 = Person2(name: "张", age: 1000)
// unexpectedly found nil while unwrapping an Optional value
print("\(person2?.name) + \(person2?.age)")


// getter 和 setter ，只供演练
class Person3: NSObject {
    
    // 属性OC中还有一个_变量，负责记录属性内容
    // 重写getter(懒加载), setter(给cell赋值)
    private var _name: String?
    var name: String? {
        get {
            // 返回一个值
            return _name
        }
        set {
            // 用一个新值设置成员变量
            _name = newValue
        }
    }
    
    // 懒加载， Swift中的特殊写法, 懒加载是一个闭包，闭包只会执行一次
    // 1. dataList能够存储字符串数组
    // 2. 当调用dataList的时候，如果没有值，会执行后面的闭包
    // 3. 结果会保存在dataList当中
    // lazy的用处，如果没有lazy，视图控制器一旦被创建，dataList就会bei初始化
    lazy var dataList: [String] = {
        print("我懒了嘛")
        return ["张三", "李四"]
        }()
    
    // 简单的懒加载写法, 如果直接返回结果，懒加载可以简化
    lazy var list: [String] = ["zhangsan", "lisi"]
    
    // 设置模型
    var model: String? {
        didSet {
            // 可以直接使用model，再也不用考虑_model = model
            // 一般情况下，不会用一个nil给对象设置数值，didSet的时候，如果小心，可以直接解包
            if let m = model {
                print("更新 UI \(m)")
            }
        }
    }
    
    // 只读属性 - "计算型属性"，根据条件计算出来，不允许修改
    // get only 属性
    var title: String? {
        return "标题" + (self.title ?? "")
    }
    
}

let person3 = Person3()
person3.name = "张三"
//person3._name = "李四"
// get only--
//person3.title = "今日头条"
print("\(person3.name)")
//print("\(person3._name)")



















//: [Next](@next)
