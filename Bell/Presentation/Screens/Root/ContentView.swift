//
//  ContentView.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/07.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel: TabViewModel

    init(viewModel: TabViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        TabView(selection: Binding<Int>(
            get: { self.viewModel.selectedTab.rawValue },
            set: { self.viewModel.setSelectedTab(tag: $0) }
        )) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tab.contentView(tabViewModel: self.viewModel)
            }
        }
    }
}

#Preview {
    ContentView(viewModel: .init())
}
