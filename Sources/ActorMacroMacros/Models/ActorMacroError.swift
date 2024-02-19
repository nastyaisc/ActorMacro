//
//  ActorMacroError.swift
//
//
//  Created by Анастасия Ищенко on 07.02.2024.
//

import Foundation

enum ActorMacroError: Error {
    
    case noTypeAnnotation(_ variableName: String)
    case invalidType
    case invalidVariable(_ variableName: String)
}

extension ActorMacroError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .noTypeAnnotation(let variableName):
            return "Для добавления методов get и set необходимо указать тип переменной \(variableName)"
        case .invalidType:
            return "Макрос @Actor может быть применен только к классу или структуре"
        case .invalidVariable(let variableName):
            return "Ошибка при обработке \(variableName)"
        }
    }
}
