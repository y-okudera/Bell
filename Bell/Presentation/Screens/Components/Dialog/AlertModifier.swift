//
//  AlertModifier.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/03.
//

import SwiftUI

struct AlertModifier: ViewModifier {
    @Binding var dialog: Dialog?

    var isPresentedAlert: Binding<Bool> {
        Binding<Bool>(
            get: { dialog?.isAlert ?? false },
            set: {
                if !$0 {
                    dialog = nil
                }
            }
        )
    }

    var isPresentedConfirm: Binding<Bool> {
        Binding<Bool>(
            get: { dialog?.isConfirm ?? false },
            set: {
                if !$0 {
                    dialog = nil
                }
            }
        )
    }

    func body(content: Content) -> some View {
        content
            .alert(
                alertViewData?.title ?? "Error",
                isPresented: isPresentedAlert
            ) {
                Button(alertViewData?.buttonText ?? "OK") {
                    alertViewData?.handler?()
                    dialog = nil
                }
            } message: {
                Text(alertViewData?.message ?? "")
            }
            .alert(
                confirmViewData?.title ?? "Error",
                isPresented: isPresentedConfirm
            ) {
                Button(confirmViewData?.secondaryButtonText ?? "Cancel") {
                    confirmViewData?.secondaryButtonHandler?()
                    dialog = nil
                }
                Button(confirmViewData?.primaryButtonText ?? "OK") {
                    confirmViewData?.primaryButtonHandler?()
                    dialog = nil
                }
            } message: {
                Text(confirmViewData?.message ?? "")
            }
    }
}

extension AlertModifier {
    var alertViewData: Dialog.AlertViewData? {
        switch dialog {
        case .alert(viewData: let viewData):
            return viewData
        case .confirm:
            return nil
        case .none:
            return nil
        }
    }

    var confirmViewData: Dialog.ConfirmViewData? {
        switch dialog {
        case .alert:
            return nil
        case .confirm(viewData: let viewData):
            return viewData
        case .none:
            return nil
        }
    }
}

extension View {
    func dialog(_ dialog: Binding<Dialog?>) -> some View {
        modifier(AlertModifier(dialog: dialog))
    }
}
