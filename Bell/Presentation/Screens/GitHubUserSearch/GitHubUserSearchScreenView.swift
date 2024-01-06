//
//  GitHubUserSearchScreenView.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/02.
//

import SwiftUI

struct GitHubUserSearchScreenView: View {
    @ObservedObject var viewModel: GitHubUserSearchViewModel = .init()

    var body: some View {
        NavigationView {
            GitHubUserSearchContentView(viewModel: self.viewModel)
                .searchable(
                    text: Binding(
                        get: { self.viewModel.searchText },
                        set: { text in self.viewModel.searchBarTextDidChange(to: text) }
                    ),
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: Text("Search Users")
                )
                .onSubmit(of: .search) {
                    self.viewModel.onSubmitSearch()
                }
                .navigationTitle(self.viewModel.navigationTitle)
                .dialog(Binding(
                    get: { self.viewModel.dialog },
                    set: { dialog in self.viewModel.dialogDidChange(to: dialog) }
                ))
        }
    }
}

#Preview {
    GitHubUserSearchScreenView()
}
