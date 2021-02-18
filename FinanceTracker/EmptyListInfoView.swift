//
//  EmptyListInfoView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 17/02/2021.
//

import SwiftUI

struct EmptyListInfoView: View {
    
    let message: String
    let btnText: String
    let btnAction: () -> Void
    
    var body: some View {
        VStack {
            Text(message)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(btnText, action: btnAction)
                .buttonStyle(PrimaryButtonStyle())
        }
    }
}
