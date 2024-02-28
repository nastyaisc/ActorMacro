//
//  ActorMacroDiagnostic.swift
//
//
//  Created by Анастасия Ищенко on 07.02.2024.
//

import Foundation
import SwiftDiagnostics

let Domain: String = "ActorMacro"

enum ActorMacroError: Error {
    
    case noTypeAnnotation(_ variableName: String)
    case invalidType
    case invalidVariable(_ variableName: String)
}

extension ActorMacroError: DiagnosticMessage {
    
    var message: String {
        switch self {
        case .noTypeAnnotation(let variableName):
            return "Для добавления методов get и set необходимо указать тип переменной \(variableName)"
        case .invalidType:
            return "Макрос @Actor может быть применен только к классу или структуре"
        case .invalidVariable(let variableName):
            return "Ошибка при обработке \(variableName)"
        }
    }
    
    var diagnosticID: SwiftDiagnostics.MessageID {
        switch self {
        case .noTypeAnnotation(let variableName):
            MessageID(domain: Domain, id: variableName)
        case .invalidType:
            MessageID(domain: Domain, id: "Invalid type")
        case .invalidVariable(let variableName):
            MessageID(domain: Domain, id: variableName)
        }
    }
    
    var severity: SwiftDiagnostics.DiagnosticSeverity {
        switch self {
        case .noTypeAnnotation, .invalidVariable:  return .warning
        case .invalidType: return .error
        }
    }
}
