//
//  SearchContentView.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/03.
//

import SwiftUI

struct SearchContentView: View {
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch
    @ObservedObject private var viewModel: GitHubRepoSearchViewModel

    init(viewModel: GitHubRepoSearchViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            if self.viewModel.isInitialLoading {
                CircularProgressView()
            } else if self.isSearching || self.viewModel.didSearchText.isEmpty && self.viewModel.data.isEmpty {
                List {
                    Section("Recommended for You") {
                        ForEach(["iOS", "Swift", "SwiftUI", "GraphQL", "Clean Architecture"], id: \.self) { text in
                            Button(text) {
                                self.viewModel.searchBarTextDidChange(to: text)
                                self.viewModel.onSubmitSearch()
                            }
                            .buttonStyle(DefaultButtonStyle())
                        }
                    }
                    .headerProminence(.increased)
                }
            } else if !self.viewModel.didSearchText.isEmpty && self.viewModel.data.isEmpty {
                Text("No repositories found.\nPlease try searching with another keyword.")
            } else {
                List {
                    ForEach(self.viewModel.data, id: \.id) { data in
                        RepositoryListItem(repository: data)
                            .listRowInsets(EdgeInsets())
                            .onAppear {
                                self.viewModel.onAppearItem(itemData: data)
                            }
                    }
                    if self.viewModel.isAdditionalLoading {
                        CircularProgressView(id: "loading_\(UUID().uuidString)")
                    }
                }
            }
        }
        .onChange(of: self.viewModel.dismissSearch) { _, newValue in
            if newValue {
                self.dismissSearch()
            }
        }
        .simultaneousGesture(
            DragGesture()
                .onChanged({ _ in
                    self.dismissSearch()
                })
        )
    }
}

#Preview {
    SearchContentView(viewModel: .init())
}
