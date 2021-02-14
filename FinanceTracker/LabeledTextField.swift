//
//  LabeledTextField.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import SwiftUI

struct LabeledTextField: ViewModifier {
    let label: String
    let errorMessage: String
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
            content
                .toInputFieldStyle()
            FormErrorMessage(errorMessage)
        }
    }
}

extension View {
    func toLabelTextField(label: String, errorMessage: String) -> some View {
        modifier(LabeledTextField(label: label, errorMessage: errorMessage))
    }
}

// MARK: -- Input Field Style

struct InputFieldStyle: ViewModifier {
    let padding: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, padding)
            .padding(.horizontal, 10)
            .background(Color("inputField"))
            .cornerRadius(15)
    }
}

extension View {
    func toInputFieldStyle(padding: CGFloat = 10) -> some View {
        modifier(InputFieldStyle(padding: padding))
    }
}
