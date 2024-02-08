//
//  File.swift
//  
//
//  Created by Анастасия Ищенко on 07.02.2024.
//

import SwiftSyntax

extension VariableDeclSyntax {
    
    func isVariablePrivate() -> Bool {
        for modifier in modifiers {
            if modifier.name.text == "private" { return true }
        }
        return false
    }
}
