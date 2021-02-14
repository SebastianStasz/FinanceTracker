//
//  LabeledPicker.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import SwiftUI

struct LabeledWheelPicker<T: Hashable>: ViewModifier {
    let label: String
    let labelFont: Font
    @Binding var selection: T

    func body(content: Content) -> some View {
        HStack(spacing: 20) {
            Text(label)
                .font(labelFont)
                .multilineTextAlignment(.center)
                .frame(maxWidth:. infinity)
            
            Picker(label, selection: $selection) { content }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: 230, maxHeight: 100)
                .clipped()
        }
    }
}

extension View {
    func embedInWheelPicker<T: Hashable>(_ label: String, labelFont: Font = .headline, selection: Binding<T>) -> some View {
        modifier(LabeledWheelPicker(label: label, labelFont: labelFont, selection: selection))
    }
}
