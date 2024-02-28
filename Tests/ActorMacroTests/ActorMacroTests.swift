import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(ActorMacroMacros)
import ActorMacroMacros

let testMacros: [String: Macro.Type] = [
    "Actor": ActorMacro.self,
]
#endif

final class ActorMacroTests: XCTestCase {
    func testMacroWithClass() throws {
        #if canImport(ActorMacroMacros)
        assertMacroExpansion(
            """
            @Actor(.private_)
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
                let testStruct2: SomeStruct = SomeStruct()
                
                init(testStruct1: SomeStruct) {
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
            """,
            expandedSource: #"""
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
                let testStruct2: SomeStruct = SomeStruct()
                
                init(testStruct1: SomeStruct) {
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
            
            private actor TestClassActor {

                private var str1: String {
                    return ""
                }
                func getStr1() -> String {
                    return str1
                }

                private var str2: String {
                    get {
                        return ""
                    }
                    set {
                        print(newValue)
                    }
                }
                func getStr2() -> String {
                    return str2
                }
                func setStr2(_ str2: String) {
                    self.str2 = str2
                }

                private let str3: String = "str3"
                func getStr3() -> String {
                    return str3
                }

                private var testStruct1: SomeStruct
                func getTestStruct1() -> SomeStruct {
                    return testStruct1
                }
                func setTestStruct1(_ testStruct1: SomeStruct) {
                    self.testStruct1 = testStruct1
                }

                private let testStruct2: SomeStruct = SomeStruct()
                func getTestStruct2() -> SomeStruct {
                    return testStruct2
                }

                init(testStruct1: SomeStruct) {
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
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testMacroWithStruct() throws {
        #if canImport(ActorMacroMacros)
        assertMacroExpansion(
            #"""
            @Actor(.internal_)
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
            """#,
            expandedSource: #"""
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
            
            actor TestStructActor {

                private var str1: String {
                    return ""
                }
                func getStr1() -> String {
                    return str1
                }
            
                private var str2: String {
                    get {
                        return ""
                    }
                    set {
                        print(newValue)
                    }
                }
                func getStr2() -> String {
                    return str2
                }
                func setStr2(_ str2: String) {
                    self.str2 = str2
                }

                private let str3: String = ""
                func getStr3() -> String {
                    return str3
                }

                private var testStruct1: SomeStruct
                func getTestStruct1() -> SomeStruct {
                    return testStruct1
                }
                func setTestStruct1(_ testStruct1: SomeStruct) {
                    self.testStruct1 = testStruct1
                }

                private let testStruct2: SomeStruct = SomeStruct()
                func getTestStruct2() -> SomeStruct {
                    return testStruct2
                }

                init(testStruct1: SomeStruct) {
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
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
