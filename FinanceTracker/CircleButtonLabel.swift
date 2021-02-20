//
//  CircleButtonLabel.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import SwiftUI

struct CircleButtonLabel: View {
    var body: some View {
        Circle().overlay(Image(systemName: icon).customize(width: btnIconSize))
            .frame(width: btnSize, height: btnSize).foregroundColor(btnColor)
    }
    
    let btnSize: CGFloat
    let btnIconSize: CGFloat
    let btnColor: Color
    let icon: String
}

extension CircleButtonLabel {
    init(btnSize: CGFloat = 60, iconSize: CGFloat = 28, color: Color = .green, SFSymbol: String = "plus") {
        self.btnSize = btnSize
        self.btnIconSize = iconSize
        self.btnColor = color
        self.icon = SFSymbol
    }
}
