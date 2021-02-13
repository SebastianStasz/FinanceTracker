//
//  ScaleOnClickButtonStyle.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import SwiftUI

struct ScaleOnClick: ButtonStyle {
    let scaledSize: CGFloat
    
    init(to scaledSize: CGFloat) {
        self.scaledSize = scaledSize
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaledSize : 1)
    }
}
