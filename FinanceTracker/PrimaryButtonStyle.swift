//
//  PrimaryButtonStyle.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    let height: CGFloat
    let width: CGFloat
    let color: Color
    
    init(width: CGFloat = 280, height: CGFloat = 60, color: Color = .blue) {
        self.height = height
        self.width = width
        self.color = color
    }
    
    func makeBody(configuration: Configuration) -> some View {
        PrimaryButton(configuration: configuration, width: width, height: height, color: color)
    }
    
    // Style

    struct PrimaryButton: View {
        @Environment(\.isEnabled) private var isEnabled: Bool
        let configuration: Configuration
        let width: CGFloat
        let height: CGFloat
        let color: Color
        
        var body: some View {
            buttonLabel.overlay(configuration.label
                                    .foregroundColor(.white))
                .opacity(configuration.isPressed ? 0.8 : 1)
        }
        var buttonLabel: some View {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(isEnabled ? color : Color.gray.opacity(0.5))
                .frame(width: width, height: height)
        }
    }
}
