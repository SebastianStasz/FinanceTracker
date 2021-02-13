//
//  Image + Extensions.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import Foundation
import SwiftUI

// MARK: -- Change Image Height

extension Image {
    func withHeight(_ height: CGFloat) -> some View {
        return self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: height)
    }
}

// MARK: -- Change Image Width

extension Image {
    func withWidth(_ width: CGFloat) -> some View {
        return self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width)
    }
}

// MARK: -- Customize Image

extension Image {
    func customize(width: CGFloat, color: Color = .black) -> some View {
        self
            .withWidth(width)
            .foregroundColor(color)
    }
}
