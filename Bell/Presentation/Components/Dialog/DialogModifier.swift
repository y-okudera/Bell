//
//  DialogModifier.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/03.
//

import SwiftUI

private struct DialogModifier: ViewModifier {
    @Binding var dialog: Dialog?

    func body(content: Content) -> some View {
        content
            .alert(
                self.alertViewData?.title ?? "Error",
                isPresented: self.isPresentedAlert
            ) {
                Button(self.alertViewData?.buttonText ?? "OK") {
                    self.alertViewData?.handler?()
                    self.dialog = nil
                }
            } message: {
                Text(self.alertViewData?.message ?? "")
            }
            .alert(
                self.confirmViewData?.title ?? "Error",
                isPresented: self.isPresentedConfirm
            ) {
                Button(self.confirmViewData?.secondaryButtonText ?? "Cancel") {
                    self.confirmViewData?.secondaryButtonHandler?()
                    self.dialog = nil
                }
                Button(self.confirmViewData?.primaryButtonText ?? "OK") {
                    self.confirmViewData?.primaryButtonHandler?()
                    self.dialog = nil
                }
            } message: {
                Text(self.confirmViewData?.message ?? "")
            }
    }

    private var isPresentedAlert: Binding<Bool> {
        Binding<Bool>(
            get: { self.dialog?.isAlert ?? false },
            set: {
                if !$0 {
                    self.dialog = nil
                }
            }
        )
    }

    private var alertViewData: Dialog.AlertViewData? {
        switch self.dialog {
        case let .alert(viewData: viewData):
            return viewData
        case .confirm:
            return nil
        case .none:
            return nil
        }
    }

    private var isPresentedConfirm: Binding<Bool> {
        Binding<Bool>(
            get: { self.dialog?.isConfirm ?? false },
            set: {
                if !$0 {
                    self.dialog = nil
                }
            }
        )
    }

    private var confirmViewData: Dialog.ConfirmViewData? {
        switch self.dialog {
        case .alert:
            return nil
        case let .confirm(viewData: viewData):
            return viewData
        case .none:
            return nil
        }
    }
}

extension View {
    func dialog(_ dialog: Binding<Dialog?>) -> some View {
        modifier(DialogModifier(dialog: dialog))
    }
}
