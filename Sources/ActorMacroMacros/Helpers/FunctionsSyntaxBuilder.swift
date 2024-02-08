//
//  FunctionsSyntaxBuilder.swift
//  
//
//  Created by Анастасия Ищенко on 07.02.2024.
//

import SwiftSyntax

struct FunctionsSyntaxBuilder {
    
    typealias FunctionParameter = (name: String, type: String)
    
    static func buildGetFunc(for variable: VariableDeclSyntax) throws -> FunctionDeclSyntax? {
        guard let variableName =  variable.bindings.as(PatternBindingListSyntax.self)?.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else {
            return nil
        }
        
        guard let returnType = variable.bindings.first?.typeAnnotation?.type else {
            // сделать возможным настройку - нужна ошибка или нет
            throw ActorMacroError.noTypeAnnotation
        }
        return FunctionDeclSyntax(
            leadingTrivia: .newline,
            // эквивалентные строки:
//            modifiers: .init(arrayLiteral: .init(name: "internal")),
            modifiers: DeclModifierListSyntax(arrayLiteral: .init(name: .keyword(.internal))),
            // эквивалентные строки:
//            funcKeyword: .init(stringInterpolation: "func"),
            funcKeyword: TokenSyntax(.keyword(.func), presence: .present),
            name: TokenSyntax(stringLiteral: "get\(StringsHelper.capitalizingFirstLetter(variableName))"),
            // доделать дженерики?
//            genericParameterClause: GenericParameterClauseSyntax?,
            signature: funcSignature(parameters: [], returnType: returnType),
            body: createGetFuncBody(variableName)
        )
    }
    
    static func buildSetFunc(for variable: VariableDeclSyntax) throws -> FunctionDeclSyntax? {
        guard let patternBinding = variable.bindings.as(PatternBindingListSyntax.self)?.first,
              let variableName =  patternBinding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
        else {
            return nil
        }
        
        guard let variableType = patternBinding.typeAnnotation?.type.as(IdentifierTypeSyntax.self)?.name.text
        else {
            throw ActorMacroError.noTypeAnnotation(variableName: variableName)
        }
        
        return FunctionDeclSyntax(
            leadingTrivia: .newline,
//            modifiers: .init(arrayLiteral: .init(name: "internal")),
            modifiers: DeclModifierListSyntax(arrayLiteral: .init(name: .keyword(.internal))),
//            funcKeyword: .init(stringInterpolation: "func"),
            funcKeyword: TokenSyntax(.keyword(.func), presence: .present),
            name: TokenSyntax(stringLiteral: "set\(StringsHelper.capitalizingFirstLetter(variableName))"),
//            genericParameterClause: GenericParameterClauseSyntax?,
            signature: funcSignature(parameters: [(variableName, variableType)], returnType: nil),
            body: createSetFuncBody((variableName, variableType))
        )
    }
    
    private static func createGetFuncBody(_ variableName: String) -> CodeBlockSyntax {
        CodeBlockSyntax.init(statements: .init(arrayLiteral: "return \(raw: variableName)"))
    }
    
    private static func funcSignature(
        parameters: [FunctionParameter],
        returnType: TypeSyntax?
    ) -> FunctionSignatureSyntax {
        //FunctionParameterListSyntax
        if let returnType {
            return FunctionSignatureSyntax(
                parameterClause: .init(parameters: createFunctionParameterList(parameters)),
                returnClause: ReturnClauseSyntax(type: returnType)
            )
        } else {
            return FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax(parameters: createFunctionParameterList(parameters))
            )
        }
    }
    
    private static func createFunctionParameterList(_ parameters: [FunctionParameter]) -> FunctionParameterListSyntax {
        var functionParameters: [FunctionParameterSyntax] = []
        parameters.forEach {
            functionParameters.append(createFunctionParameter($0))
        }
        // создаем список параметров функции из отдельных параметров
        return FunctionParameterListSyntax.init(functionParameters)
    }
    
    private static func createFunctionParameter(_ parameter: FunctionParameter) -> FunctionParameterSyntax {
        // создание одного параметра для функции
        return FunctionParameterSyntax(
            firstName: TokenSyntax(.wildcard, presence: .present), // нижнее подчеркивание, чтобы при вызове функции параметор модно было игнорировать. В случае, если у параметра нет двух имен, то имя параметра указывается в этом поле, а не следующем
            secondName: TokenSyntax(stringLiteral: "\(parameter.name)"),
            colon: .colonToken(),
            type: IdentifierTypeSyntax.init(name: .init(stringLiteral: parameter.type))
        )
    }
    
    private static func createSetFuncBody(_ functionParameter: FunctionParameter) -> CodeBlockSyntax {
        CodeBlockSyntax.init(statements: .init(
            arrayLiteral: "self.\(raw: functionParameter.name) = \(raw: functionParameter.name)"
        ))
    }
}
