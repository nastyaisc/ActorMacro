//
//  StringsHelper.swift
//  
//
//  Created by Анастасия Ищенко on 07.02.2024.
//

import SwiftSyntax

struct StringsHelper {
    
    /// Убирает один уровень отступов слева
    /// 1 - Считаем кол-во пробелов, которые необходимо убрать
    /// 2 - Заменяем последовательность перехода на новую строку и отступа просто на переход на новую строку
    static func removeLeadingTriviaFromMemberBlock(_ memberBlock: MemberBlockItemSyntax) -> MemberBlockItemSyntax {
        var resultMemberBlock: MemberBlockItemSyntax = memberBlock
        memberBlock.leadingTrivia.forEach {
            switch $0 {
            case .spaces(let count): // 1
                let declWithTrimmedTabs = memberBlock.decl.description.replacingOccurrences(of: "\n" + String(repeating: " ", count: count), with: "\n") // 2
                resultMemberBlock = MemberBlockItemSyntax(decl: DeclSyntax(stringLiteral: declWithTrimmedTabs))
                return
            default:
                break
            }
        }
        return resultMemberBlock
    }
    
    static func capitalizingFirstLetter(_ string: String) -> String {
        return string.prefix(1).uppercased() + string.dropFirst()
    }
}
