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
            if self.viewModel.isInitialLoading {
                CircularProgressView()
            } else if self.isSearching || self.viewModel.didSearchText.isEmpty && self.viewModel.data.isEmpty {
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
            } else if !self.viewModel.didSearchText.isEmpty && self.viewModel.data.isEmpty {
                Text("No users found.\nPlease try searching with another keyword.")
            } else {
                ScrollViewReader(content: { proxy in
                    List {
                        ForEach(self.viewModel.data, id: \.id) { data in
                            UserListItem(user: data)
                                .id(self.viewModel.data.first?.id == data.id ? "top" : nil)
                                .listRowInsets(EdgeInsets())
                                .onAppear {
                                    self.viewModel.onAppearItem(itemData: data)
                                }
                        }
                        if self.viewModel.isAdditionalLoading {
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
        .onAppear {
            defer {
                self.dismissSearchTrigger = false
            }
            if dismissSearchTrigger {
                self.dismissSearch()
            }
        }
        .onChange(of: dismissSearchTrigger, { _, newValue in
            defer {
                self.dismissSearchTrigger = false
            }
            if newValue {
                self.dismissSearch()
            }
        })
    }
}

#Preview {
    GitHubUserSearchContentView(viewModel: .init(), dismissSearchTrigger: .constant(false))
        .environmentObject(TabViewModel())
}
