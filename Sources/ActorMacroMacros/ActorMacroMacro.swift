import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Все  функции просто перенести в новый актор
/// переменные сделать приватными и создать для каждой методы гет и сет
/// 1. Достать имя
/// 2. Создать функцию с таким именем + get/set и принимаемым/возвращаемым значением
/// Добавить настройку для переменных :
/// 1. Приватные/не приватные (по умолчанию приватные) - отдельно для каждой с помощью аттрибута и для всех сразу с помощью параметра макроса
/// 2. Нужен геттер сеттер для переменной/всего класса сразу или нет (по умолчанию нужен)
/// 3. Какие нужны функции - для всего класса (open/internal)
/// 4. Доступность самого актора - по умолчанию равна доступности класса

public struct ActorMacro: PeerMacro {
    
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        
        if let classSyntax = declaration.as(ClassDeclSyntax.self),
           let declSyntax = try SyntaxBuilder.buildClass(classSyntax).as(DeclSyntax.self) {
            return [declSyntax]
        } else if let structSyntax = declaration.as(StructDeclSyntax.self),
                  let declSyntax = try SyntaxBuilder.buildStruct(structSyntax).as(DeclSyntax.self) {
            return [declSyntax]
        } else {
            throw ActorMacroError.invalidType
        }
    }
}

@main
struct ActorMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ActorMacro.self,
    ]
}
