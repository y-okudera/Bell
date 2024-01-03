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
        VStack {
            if self.isSearching || self.viewModel.didSearchText.isEmpty && self.viewModel.data.isEmpty {
                List {
                    Section("Recommended for You") {
                        self.suggestButton(text: "Swift")
                        self.suggestButton(text: "SwiftUI")
                        self.suggestButton(text: "GraphQL")
                    }
                    .headerProminence(.increased)
                }
            } else if !self.viewModel.didSearchText.isEmpty && self.viewModel.data.isEmpty {
                Text("No repositories found.\nPlease try searching with another keyword.")
            } else {
                List {
                    ForEach(self.viewModel.data, id: \.self) { data in
                        RepositoryListItem(repository: data)
                            .onAppear {
                                self.viewModel.onAppearItem(itemData: data)
                            }
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

    private func suggestButton(text: String) -> some View {
        Button {
            self.viewModel.searchBarTextDidChange(to: text)
            self.viewModel.onSubmitSearch()
        } label: {
            Text(text)
                .foregroundColor(.accentColor)
                .background(Color(UIColor.systemBackground))
        }
    }
}

#Preview {
    SearchContentView(viewModel: .init())
}
