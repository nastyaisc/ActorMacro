//
//  SyntaxBuilder.swift
//
//
//  Created by Анастасия Ищенко on 07.02.2024.
//

import SwiftSyntax

struct SyntaxBuilder {
    
    static func buildClass(_ classSyntax: ClassDeclSyntax) throws -> ActorDeclSyntax {
        let className = classSyntax.name
        let members = classSyntax.memberBlock.members
        
        return ActorDeclSyntax(
            modifiers: classSyntax.modifiers,
            actorKeyword: .init(.keyword(.actor), presence: .present),
            name: TokenSyntax(stringLiteral: "\(className.text)Actor"),
            genericParameterClause: classSyntax.genericParameterClause,
            inheritanceClause: classSyntax.inheritanceClause,
            genericWhereClause: classSyntax.genericWhereClause,
            memberBlock: try extractMembers(members)
        )
        
    }
    
    static func buildStruct(_ structSyntax: StructDeclSyntax) throws -> ActorDeclSyntax {
        let structName = structSyntax.name
        let members = structSyntax.memberBlock.members
        
        return ActorDeclSyntax(
            modifiers: structSyntax.modifiers,
            actorKeyword: .init(.keyword(.actor), presence: .present),
            name: TokenSyntax(stringLiteral: "\(structName.text)Actor"),
            genericParameterClause: structSyntax.genericParameterClause,
            inheritanceClause: structSyntax.inheritanceClause,
            genericWhereClause: structSyntax.genericWhereClause,
            memberBlock: try extractMembers(members)
        )
    }
    
    private static func buildVariable(_ variable: VariableDeclSyntax) -> VariableDeclSyntax {
        /// При использовании готового синтаксиса кода, важно помнить про отступы.
        /// Важно следить, чтобы переменная не имела лишних отступов, например, при использовании код:
        ///        var editableVariable = variable
        ///        editableVariable.modifiers = .init(arrayLiteral: .init(name: .keyword(.private)))
        ///        editableVariable.leadingTrivia = .newlines(2)
        /// При входных данных:
        ///         let testStr: String
        /// Приведет к результату:
        ///         private
        ///                let testStr: String
        ///
        /// Корректный код:
        var editableVariable = variable
        editableVariable.modifiers = .init(arrayLiteral: .init(name: .keyword(.private)))
        editableVariable.leadingTrivia = .newlines(2)
        editableVariable.bindingSpecifier.leadingTrivia = .space
        /// Результат:
        ///        private let testStr: String
        return editableVariable
    }
    
    private static func extractMembers(_ members: MemberBlockItemListSyntax) throws -> MemberBlockSyntax {
        var memberBlockItems: [MemberBlockItemSyntax] = []
        try members.forEach { member in
            if let variable = member.decl.as(VariableDeclSyntax.self),
               !variable.isVariablePrivate() {
                
                let resultVariable = buildVariable(variable)
                memberBlockItems.append(MemberBlockItemSyntax(decl: resultVariable))
                
                if let getterForVariable = try FunctionsSyntaxBuilder.buildGetFunc(for: variable) {
                    memberBlockItems.append(MemberBlockItemSyntax(decl: getterForVariable))
                }
                if variable.bindingSpecifier.text != "let",
                   let setterForVariable = try FunctionsSyntaxBuilder.buildSetFunc(for: variable) {
                    memberBlockItems.append(MemberBlockItemSyntax(decl: setterForVariable))
                }
            } else {
                memberBlockItems.append(StringsHelper.removeLeadingTriviaFromMemberBlock(member))
            }
        }
        return MemberBlockSyntax(members: MemberBlockItemListSyntax(memberBlockItems))
    }
}
