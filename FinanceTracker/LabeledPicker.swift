//
//  LabeledPicker.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import SwiftUI

struct LabeledWheelPicker<T: Hashable>: ViewModifier {
    let label: String
    let height: CGFloat
    @Binding var selection: T

    func body(content: Content) -> some View {
        Picker(label, selection: $selection) { content }
            .pickerStyle(WheelPickerStyle())
            .frame(maxHeight: height)
            .clipped()
    }
}

extension View {
    func embedInWheelPicker<T: Hashable>(_ label: String, selection: Binding<T>, height: CGFloat = 100) -> some View {
        modifier(LabeledWheelPicker(label: label, height: height, selection: selection))
    }
}
