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
            .environmentObject(tabViewModel)
            .navigationTitle(self.viewModel.navigationTitle)
            .searchable(
                text: self.$viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text("Search Repositories")
            )
            .onSubmit(of: .search) {
                self.viewModel.onSubmitSearch()
            }
            .onChange(of: self.viewModel.dismissSearch) { _, newValue in
                self.dismissSearchTrigger = newValue
            }
            .dialog(self.$viewModel.dialog)
    }
}

#Preview {
    GitHubRepoSearchScreenView(viewModel: .init(), dismissSearchTrigger: false)
        .environmentObject(TabViewModel())
}
