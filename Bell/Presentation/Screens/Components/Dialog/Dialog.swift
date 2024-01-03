//
//  Dialog.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/03.
//

import Foundation

enum Dialog {
    case alert(viewData: AlertViewData)
    case confirm(viewData: ConfirmViewData)

    struct AlertViewData {
        let title: String
        let message: String
        let buttonText: String
        let handler: (() -> Void)?
    }

    struct ConfirmViewData {
        let title: String
        let message: String
        let primaryButtonText: String
        let secondaryButtonText: String
        let primaryButtonHandler: (() -> Void)?
        let secondaryButtonHandler: (() -> Void)?
    }

    var isAlert: Bool {
        switch self {
        case .alert:
            return true
        case .confirm:
            return false
        }
    }

    var isConfirm: Bool {
        switch self {
        case .alert:
            return false
        case .confirm:
            return true
        }
    }
}
