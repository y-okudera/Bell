//
//  GitHubRepoSearchContentView.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/03.
//

import SwiftUI

struct GitHubRepoSearchContentView: View {
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch
    @EnvironmentObject private var tabViewModel: TabViewModel
    @ObservedObject private var viewModel: GitHubRepoSearchViewModel
    @Binding private var dismissSearchTrigger: Bool

    init(
        viewModel: GitHubRepoSearchViewModel,
        dismissSearchTrigger: Binding<Bool>
    ) {
        self._viewModel = .init(wrappedValue: viewModel)
        self._dismissSearchTrigger = dismissSearchTrigger
    }

    var body: some View {
        Group {
            if isSearching {
                self.recommendedKeywordsList()
            } else {
                switch self.viewModel.loadingState {
                case .idle:
                    self.recommendedKeywordsList()
                case .initialLoading:
                    CircularProgressView()
                case .emptyState:
                    Text("No repositories found.\nPlease try searching with another keyword.")
                case let .loaded(repositories, isAdditionalLoading):
                    ScrollViewReader(content: { proxy in
                        List {
                            ForEach(repositories, id: \.id) { repo in
                                RepositoryListItem(repository: repo)
                                    .id(repositories.first?.id == repo.id ? "top" : nil)
                                    .listRowInsets(.init())
                                    .onAppear {
                                        self.viewModel.onAppearItem(itemData: repo)
                                    }
                            }
                            if isAdditionalLoading {
                                CircularProgressView(id: "loading_\(UUID().uuidString)")
                            }
                        }
                        .onChange(of: self.tabViewModel.activeTabTapped[.repoSearch]) {
                            withAnimation {
                                proxy.scrollTo("top", anchor: .top)
                            }
                        }
                    })
                }
            }
        }
        .onAppear {
            defer {
                self.dismissSearchTrigger = false
            }
            if self.dismissSearchTrigger {
                self.dismissSearch()
            }
        }
        .onChange(of: self.dismissSearchTrigger, { _, newValue in
            defer {
                self.dismissSearchTrigger = false
            }
            if newValue {
                self.dismissSearch()
            }
        })
    }

    @ViewBuilder
    private func recommendedKeywordsList() -> some View {
        List {
            Section("Recommended for You") {
                ForEach(["iOS", "Swift", "SwiftUI", "GraphQL", "Clean Architecture"], id: \.self) { text in
                    Button(text) {
                        self.viewModel.onChooseRecommendedKeyword(text)
                    }
                    .buttonStyle(DefaultButtonStyle())
                }
            }
            .headerProminence(.increased)
        }
        .simultaneousGesture(
            DragGesture()
                .onChanged { _ in
                    self.dismissSearch()
                    self.dismissSearchTrigger = false
                }
        )
    }
}

#Preview {
    GitHubRepoSearchContentView(viewModel: .init(), dismissSearchTrigger: .constant(false))
        .environmentObject(TabViewModel())
}
