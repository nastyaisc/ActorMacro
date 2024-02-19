//
//  File.swift
//  
//
//  Created by Анастасия Ищенко on 07.02.2024.
//

import SwiftSyntax

extension VariableDeclSyntax {
    
    var isPrivate: Bool {
        for modifier in modifiers {
            if modifier.name.text == "private" { return true }
        }
        return false
    }
    
    var isGetOnly: Bool {
        bindings.first?.accessorBlock?.accessors.is(CodeBlockItemListSyntax.self) == true
    }
    
    var isStoredProperty: Bool {
        bindings.first?.accessorBlock == nil
    }
}
