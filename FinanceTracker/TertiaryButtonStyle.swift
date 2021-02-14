//
//  TertiaryButtonStyle.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import SwiftUI

struct TertiaryButtonStyle: ButtonStyle {
    let SFSymbol: String
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 3) {
            Image(systemName: SFSymbol)
            configuration.label
        }
        .foregroundColor(.blue)
        .opacity(configuration.isPressed ? 0.8 : 1)
        .padding(.leading, 10)
        .contentShape(Rectangle())
    }
}
