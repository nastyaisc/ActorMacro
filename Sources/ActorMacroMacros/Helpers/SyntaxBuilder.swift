//
//  SyntaxBuilder.swift
//
//
//  Created by Анастасия Ищенко on 07.02.2024.
//

import SwiftSyntax
import SwiftSyntaxMacros

final class SyntaxBuilder: DiagnosticCapableBase {
    
    private lazy var functionsBuilder = FunctionsSyntaxBuilder(
        node: node,
        context: context
    )
    
    func buildClass(
        _ classSyntax: ClassDeclSyntax,
        with modifiers: DeclModifierListSyntax?
    ) throws -> ActorDeclSyntax {
        let className = classSyntax.name
        let members = classSyntax.memberBlock.members
        
        return ActorDeclSyntax(
            modifiers: modifiers ?? classSyntax.modifiers,
            actorKeyword: .init(.keyword(.actor), presence: .present),
            name: TokenSyntax(stringLiteral: "\(className.text)Actor"),
            genericParameterClause: classSyntax.genericParameterClause,
            inheritanceClause: classSyntax.inheritanceClause,
            genericWhereClause: classSyntax.genericWhereClause,
            memberBlock: try extractMembers(members)
        )
        
    }
    
    func buildStruct(_ structSyntax: StructDeclSyntax) throws -> ActorDeclSyntax {
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
    
    private func buildVariable(_ variable: VariableDeclSyntax) throws -> VariableDeclSyntax? {
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
        guard let decl = variable.as(DeclSyntax.self),
              var newVariable = VariableDeclSyntax(StringsHelper.removeLeadingTriviaFromDecl(decl))
        else {
            try showDiagnostic(
                ActorMacroError.invalidVariable(variable.bindings.as(PatternBindingListSyntax.self)?.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text ?? "?unknown variable name?")
            )
            return nil
        }
        newVariable.modifiers = .init(arrayLiteral: .init(name: .keyword(.private)))
        newVariable.leadingTrivia = .newlines(2)
        newVariable.bindingSpecifier.leadingTrivia = .space
        
        return newVariable
        /// Результат:
        ///        private let testStr: String
//        return editableVariable
    }
    
    private func extractMembers(_ members: MemberBlockItemListSyntax) throws -> MemberBlockSyntax {
        var variables: [VariableDeclSyntax] = []
        var createdMemberBlockItems: [MemberBlockItemSyntax] = []
        var memberBlockItems: [MemberBlockItemSyntax] = []
         
        var hasInit = false
        try members.forEach { member in
            if member.decl.is(InitializerDeclSyntax.self) {
                hasInit = true
            }
            
            if let variable = member.decl.as(VariableDeclSyntax.self) {
                variables.append(variable)
                if !variable.isPrivate {
                    if let resultVariable = try buildVariable(variable) {
                        createdMemberBlockItems.append(MemberBlockItemSyntax(decl: resultVariable))
                    }
                    
                    if let getterForVariable = try functionsBuilder.buildGetFunc(for: variable) {
                        createdMemberBlockItems.append(MemberBlockItemSyntax(decl: getterForVariable))
                    }
                    if shouldCreateSetFunc(for: variable),
                       let setterForVariable = try functionsBuilder.buildSetFunc(for: variable) {
                        createdMemberBlockItems.append(MemberBlockItemSyntax(decl: setterForVariable))
                    }
                } else if let configuredMember = configureMember(member) {
                    createdMemberBlockItems.append(configuredMember)
                }
            } else if let configuredMember = configureMember(member) {
                memberBlockItems.append(configuredMember)
            }
        }
        
        // в случае, если у структуры нет нициализатора, генерируем простейший его вид
        if !hasInit {
            createdMemberBlockItems.append(MemberBlockItemSyntax(decl: functionsBuilder.buidInit(variables: variables)))
        }
        let resultMembers = createdMemberBlockItems + memberBlockItems
        
        return MemberBlockSyntax(members: MemberBlockItemListSyntax(resultMembers))
    }
    
    private func shouldCreateSetFunc(
        for variable: VariableDeclSyntax
    ) -> Bool {
        variable.bindingSpecifier.text != "let" && !variable.isGetOnly
    }
    
    private func configureMember(
        _ member: MemberBlockItemSyntax
    ) -> MemberBlockItemSyntax? {
        MemberBlockItemSyntax(
            decl:  StringsHelper.removeLeadingTriviaFromDecl(member.decl)
        )
    }
}
