//
//  PopUpViewModifier.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 17/02/2021.
//

import SwiftUI

struct PopUpView: ViewModifier {
    
    let buttonsHeight: CGFloat
    let buttonsWidth: CGFloat
    
    let isActionBtnDisabled: Bool
    let actionBtnText: String
    
    let cancleBtn: () -> Void
    let actionBtn: () -> Void
    
    // MARK: -- Main View
    
    func body(content: Content) -> some View {
        VStack(spacing: 20) {
            
            content
            
            closeAndActionButtons
            
        }
        .padding(contentPadding)
        .frame(width: windowWidth)
        .background(popUpWindowBackground)
    }
    
    // MARK: -- View Components
    
    var closeAndActionButtons: some View {
        HStack {
            Button("Cancel", action: cancleBtn)
                .buttonStyle(PrimaryButtonStyle(width: buttonsWidth, height: buttonsHeight,  color: .red))
            
            Spacer()
            
            Button(actionBtnText, action: actionBtn)
                .buttonStyle(PrimaryButtonStyle(width: buttonsWidth, height: buttonsHeight))
                .disabled(isActionBtnDisabled)
        }
    }
    
    var popUpWindowBackground: some View {
        backgroundColor.cornerRadius(windowCornerRadius)
            .shadow(color: Color.primary.opacity(0.3), radius: windowShadowRadius)
    }
    
    // MARK: -- View Settings

    let windowWidth: CGFloat = 340
    let contentPadding: CGFloat = 30

    let backgroundColor = Color("primaryInvert").opacity(0.95)
    let windowCornerRadius: CGFloat = 15
    let windowShadowRadius: CGFloat = 30
}


extension View {
    
    func embedInPopUpView(btnsHeight: CGFloat,
                          btnsWidth: CGFloat,
                          isActionBtnDisabled: Bool,
                          actionBtnText: String,
                          cancelBtn: @escaping () -> Void,
                          actionBtn: @escaping () -> Void) -> some View {
        
        modifier(PopUpView(buttonsHeight: btnsHeight,
                           buttonsWidth: btnsWidth,
                           isActionBtnDisabled: isActionBtnDisabled,
                           actionBtnText: actionBtnText,
                           cancleBtn: cancelBtn,
                           actionBtn: actionBtn))
    }
}




