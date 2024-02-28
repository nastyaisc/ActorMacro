//
//  DiagnosticCapable.swift
//
//
//  Created by Анастасия Ищенко on 28.02.2024.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

class DiagnosticCapableBase {
    
    let node: SyntaxProtocol
    let context: MacroExpansionContext
    
    init(node: SyntaxProtocol, context: some MacroExpansionContext) {
        self.node = node
        self.context = context
    }
    
    func showDiagnostic(_ error: ActorMacroError) throws {
        switch error.severity {
        case .error:
            context.diagnose(Diagnostic(node: node, message: error))
            throw error
        default:
            context.diagnose(Diagnostic(node: node, message: error))
        }
    }
}
