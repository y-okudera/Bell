//
//  GitHubRepoSearchScreenView.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/02.
//

import SwiftUI

struct GitHubRepoSearchScreenView: View {
    @EnvironmentObject private var tabViewModel: TabViewModel
    @StateObject private var viewModel: GitHubRepoSearchViewModel
    @State private var dismissSearchTrigger: Bool

    init(
        viewModel: GitHubRepoSearchViewModel,
        dismissSearchTrigger: Bool
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.dismissSearchTrigger = dismissSearchTrigger
    }

    var body: some View {
        GitHubRepoSearchContentView(viewModel: self.viewModel, dismissSearchTrigger: self.$dismissSearchTrigger)
            .environmentObject(self.tabViewModel)
            .navigationTitle(self.viewModel.navigationTitle)
            .searchable(
                text: self.$viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text("Search Repositories")
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
    GitHubRepoSearchScreenView(viewModel: .init(), dismissSearchTrigger: false)
        .environmentObject(TabViewModel())
}
