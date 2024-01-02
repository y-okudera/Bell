//
//  GitHubRepoSearchScreenView.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/02.
//

import SwiftUI

struct GitHubRepoSearchScreenView: View {
    @ObservedObject var viewModel: GitHubRepoSearchViewModel = .init()

    var body: some View {
        NavigationView {
            SearchContentView(viewModel: self.viewModel)
                .searchable(
                    text: Binding(
                        get: { self.viewModel.searchText },
                        set: { text in self.viewModel.searchBarTextDidChange(to: text) }
                    ),
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: Text("Search Repositories")
                )
                .onSubmit(of: .search) {
                    self.viewModel.onSubmitSearch()
                }
                .navigationTitle(self.viewModel.navigationTitle)
        }
    }
}

#Preview {
    GitHubRepoSearchScreenView()
}
