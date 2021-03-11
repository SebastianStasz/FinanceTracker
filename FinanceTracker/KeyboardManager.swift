//
//  KeyboardHelper.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 17/02/2021.
//

import Foundation
import SwiftUI

class KeyboardManager: ObservableObject {
    private var keyboardHelper: KeyboardHelper?
    @Published private(set) var isShown = false
    
    init() {
        keyboardHelper = KeyboardHelper { [self] animation, keyboardFrame, duration in
            switch animation {
            case .keyboardWillShow: isShown = true
            case .keyboardWillHide: isShown = false
            }
        }
    }
}

// MARK: -- Keyboard Helper

final class KeyboardHelper {
    private let handleBlock: HandleBlock

    init(handleBlock: @escaping HandleBlock) {
        self.handleBlock = handleBlock
        setupNotification()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupNotification() {
        _ = NotificationCenter.default
            .addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] notification in
                self?.handle(animation: .keyboardWillShow, notification: notification)
            }

        _ = NotificationCenter.default
            .addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] notification in
                self?.handle(animation: .keyboardWillHide, notification: notification)
            }
    }

    private func handle(animation: Animation, notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }

        handleBlock(animation, keyboardFrame, duration)
    }
}

extension KeyboardHelper {
    enum Animation {
        case keyboardWillShow
        case keyboardWillHide
    }

    typealias HandleBlock = (_ animation: Animation, _ keyboardFrame: CGRect, _ duration: TimeInterval) -> Void
}
