import ActorMacro

struct SomeStruct {}

@Actor(.fileprivate_)
class TestClass {
    
    var str1: String {
        return ""
    }
    var str2: String {
        get {
            return ""
        }
        set {
            print(newValue)
        }
    }
    let str3: String = "str3"
    var testStruct1: SomeStruct
    let testStruct2 = SomeStruct()
    
    init(str2: String, testStruct1: SomeStruct) {
        self.testStruct1 = testStruct1
    }
    
    static func testStaticFunc(test: TestStruct) -> String {
        if !test.str3.isEmpty {
            return test.str3
        }
        return ""
    }
    
    func testFunc() -> String {
        if !str1.isEmpty {
            return str1
        }
        return str2
    }
    
    private func testPrivateFunc(test: TestStruct) -> String {
        if !test.str3.isEmpty {
            return str1
        }
        return str2
    }
}

//@Actor
//enum Type {}

//@Actor
struct TestStruct {
    
    var str1: String {
        return ""
    }
    var str2: String {
        get {
            return ""
        }
        set {
            print(newValue)
        }
    }
    let str3: String = ""
    var testStruct1: SomeStruct
    let testStruct2: SomeStruct = SomeStruct()
    
    static func testStaticFunc(test: TestStruct) -> String {
        if !test.str3.isEmpty {
            return test.str3
        }
        return ""
    }
    
    func testFunc() -> String {
        if !str1.isEmpty {
            return str1
        }
        return str2
    }
    
    private func testPrivateFunc(test: TestStruct) -> String {
        if !test.str3.isEmpty {
            return str1
        }
        return str2
    }
}

