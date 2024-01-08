//
//  GitHubUserSearchContentView.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/03.
//

import SwiftUI

struct GitHubUserSearchContentView: View {
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch
    @EnvironmentObject private var tabViewModel: TabViewModel
    @ObservedObject private var viewModel: GitHubUserSearchViewModel
    @Binding private var dismissSearchTrigger: Bool

    init(
        viewModel: GitHubUserSearchViewModel,
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
                    Text("No users found.\nPlease try searching with another keyword.")
                case let .loaded(users, isAdditionalLoading):
                    ScrollViewReader(content: { proxy in
                        List {
                            ForEach(users, id: \.id) { user in
                                UserListItem(user: user)
                                    .id(users.first?.id == user.id ? "top" : nil)
                                    .listRowInsets(.init())
                                    .onAppear {
                                        self.viewModel.onAppearItem(itemData: user)
                                    }
                            }
                            if isAdditionalLoading {
                                CircularProgressView(id: "loading_\(UUID().uuidString)")
                            }
                        }
                        .onChange(of: self.tabViewModel.activeTabTapped[.userSearch]) {
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
                ForEach(["Apple", "Google"], id: \.self) { text in
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
    GitHubUserSearchContentView(viewModel: .init(), dismissSearchTrigger: .constant(false))
        .environmentObject(TabViewModel())
}
