//
//  GitHubUserSearchScreenView.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/02.
//

import SwiftUI

struct GitHubUserSearchScreenView: View {
    @EnvironmentObject private var tabViewModel: TabViewModel
    @StateObject private var viewModel: GitHubUserSearchViewModel
    @State private var dismissSearchTrigger: Bool

    init(
        viewModel: GitHubUserSearchViewModel,
        dismissSearchTrigger: Bool
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.dismissSearchTrigger = dismissSearchTrigger
    }

    var body: some View {
        GitHubUserSearchContentView(viewModel: self.viewModel, dismissSearchTrigger: self.$dismissSearchTrigger)
            .environmentObject(self.tabViewModel)
            .navigationTitle(self.viewModel.navigationTitle)
            .searchable(
                text: self.$viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text("Search Users")
            )
            .onSubmit(of: .search) {
                self.viewModel.onSubmitSearch()
            }
            .onChange(of: self.viewModel.loadingState) { _, newValue in
                switch newValue {
                case .idle, .initialLoading:
                    self.dismissSearchTrigger = false
                case .emptyState, .loaded:
                    self.dismissSearchTrigger = true
                }
            }
            .dialog(self.$viewModel.dialog)
    }
}

#Preview {
    GitHubUserSearchScreenView(viewModel: .init(), dismissSearchTrigger: false)
        .environmentObject(TabViewModel())
}
