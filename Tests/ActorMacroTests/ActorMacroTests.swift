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
            @Actor
            class TestClass {
                
                private var str1: String
                private let str2: String
                let str3: String = "str3"
                var testStruct1: SomeStruct
                let testStruct2: SomeStruct = SomeStruct()
                
                init(str1: String, str2: String, testStruct1: SomeStruct) {
                    self.str1 = str1
                    self.str2 = str2
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
                
                private func testPrivateFunc(test: TestStruct, test2: TestStruct) -> String {
                    if !test.str3.isEmpty {
                        return str1
                    }
                    return str2
                }
            }
            """,
            expandedSource: #"""
            class TestClass {
                
                private var str1: String
                private let str2: String
                let str3: String = "str3"
                var testStruct1: SomeStruct
                let testStruct2: SomeStruct = SomeStruct()
                
                init(str1: String, str2: String, testStruct1: SomeStruct) {
                    self.str1 = str1
                    self.str2 = str2
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
                
                private func testPrivateFunc(test: TestStruct, test2: TestStruct) -> String {
                    if !test.str3.isEmpty {
                        return str1
                    }
                    return str2
                }
            }
            
            actor TestClassActor {

                private var str1: String
                private let str2: String

                private let str3: String = "str3"
                internal func getStr3() -> String {
                    return str3
                }

                private var testStruct1: SomeStruct
                internal func getTestStruct1() -> SomeStruct {
                    return testStruct1
                }
                internal func setTestStruct1(_ testStruct1: SomeStruct) {
                    self.testStruct1 = testStruct1
                }

                private let testStruct2: SomeStruct = SomeStruct()
                internal func getTestStruct2() -> SomeStruct {
                    return testStruct2
                }

                init(str1: String, str2: String, testStruct1: SomeStruct) {
                    self.str1 = str1
                    self.str2 = str2
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

                private func testPrivateFunc(test: TestStruct, test2: TestStruct) -> String {
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
            @Actor
            struct TestStruct {
                
                private var str1: String
                private let str2: String
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
                
                private var str1: String
                private let str2: String
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

                private var str1: String
                private let str2: String

                private let str3: String = ""
                internal func getStr3() -> String {
                    return str3
                }

                private var testStruct1: SomeStruct
                internal func getTestStruct1() -> SomeStruct {
                    return testStruct1
                }
                internal func setTestStruct1(_ testStruct1: SomeStruct) {
                    self.testStruct1 = testStruct1
                }

                private let testStruct2: SomeStruct = SomeStruct()
                internal func getTestStruct2() -> SomeStruct {
                    return testStruct2
                }

                internal init(str1: String, str2: String, testStruct1: SomeStruct) {
                    self.str1 = str1
                    self.str2 = str2
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
