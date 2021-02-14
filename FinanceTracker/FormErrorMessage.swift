//
//  FormErrorMessage.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import SwiftUI

// TODO: Fix / change animation for showing error message
struct FormErrorMessage: View {
    let text: String
    var isVisible: Bool { !text.isEmpty }
    
    var body: some View {
        Text(text)
            .font(.callout)
            .foregroundColor(.red)
            .padding(.top, 3)
            .padding(.bottom, 6)
            .animation(.easeInOut)
            .opacity(isVisible ? 1 : 0)
    }
}

extension FormErrorMessage {
    init(_ message: String) {
        text = message
    }
}
