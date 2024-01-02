//
//  SearchContentView.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/03.
//

import GraphQL_Domain
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
                    ForEach(self.viewModel.data, id: \.self) {
                        self.repositoryListItem(data: $0)
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

    private func repositoryListItem(data: GitHubRepoListResponse.Edge.Node) -> some View {
        HStack {
            AsyncImage(url: data.owner.avatarUrl) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            VStack {
                Text(data.nameWithOwner)
                    .bold()
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .topLeading)

                Text(data.description ?? "-")
                    .foregroundStyle(.secondary)
                    .lineLimit(2, reservesSpace: true)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
    }
}

#Preview {
    SearchContentView(viewModel: .init())
}
