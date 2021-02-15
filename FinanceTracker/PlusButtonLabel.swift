//
//  PlusButtonLabel.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import SwiftUI

struct PlusButtonLabel: View {
    var body: some View {
        Circle().overlay(Image(systemName: "plus").customize(width: btnIconSize))
            .frame(width: btnSize, height: btnSize).foregroundColor(btnColor)
    }
    
    let btnSize: CGFloat
    let btnIconSize: CGFloat
    let btnColor = Color.green
}

extension PlusButtonLabel {
    init(btnSize: CGFloat, iconSize: CGFloat) {
        self.btnSize = btnSize
        self.btnIconSize = iconSize
    }
}
