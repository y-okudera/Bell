//
//  CircularProgressView.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/03.
//

import SwiftUI

struct CircularProgressView: View {
    let id: String?

    init(id: String? = nil) {
        self.id = id
    }

    var body: some View {
        ProgressView()
            .id(self.id)
            .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: .primary))
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    CircularProgressView()
}
