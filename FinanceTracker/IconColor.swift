//
//  IconColor.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 11/02/2021.
//

import Foundation
import SwiftUI

enum IconColor: String, CaseIterable {
    case red = "red"
    case orange = "orange"
    case yellow = "yellow"
    case green1 = "green1"
    case green2 = "green2"
    case blue1 = "blue1"
    case blue2 = "blue2"
    case purple = "purple"
    case pink = "pink"
    case gray = "gray"
    
    var color: Color {
        switch self {
        case .red: return Color(red: 1, green: 0, blue: 0)
        case .orange: return Color(red: 1, green: 128/255, blue: 0)
        case .yellow: return Color(red: 1, green: 1, blue: 0)
        case .green1: return Color(red: 128/255, green: 1, blue: 0)
        case .green2: return Color(red: 0, green: 1, blue: 0)
        case .blue1: return Color(red: 0, green: 0, blue: 1)
        case .blue2: return Color(red: 0, green: 1, blue: 1)
        case .purple: return Color(red: 127/255, green: 0, blue: 1)
        case .pink: return Color(red: 1, green: 0, blue: 127/255)
        case .gray: return Color(red: 128/255, green: 128/255, blue: 128/255)
        }
    }
}

extension IconColor: Identifiable {
    var id: IconColor { self }
}
