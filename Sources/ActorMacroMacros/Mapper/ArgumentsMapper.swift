//
//  ArgumentsMapper.swift
//
//
//  Created by Анастасия Ищенко on 29.02.2024.
//

import SwiftSyntax

struct ArgumentsMapper {
    
    static func mapProtectionLevel(_ level: LabeledExprSyntax?) -> DeclModifierListSyntax? {
        guard let name = level?.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text
        else { return nil }
        return DeclModifierListSyntax(arrayLiteral: .init(name: TokenSyntax(stringLiteral: String(name.dropLast()))))
    }
}
