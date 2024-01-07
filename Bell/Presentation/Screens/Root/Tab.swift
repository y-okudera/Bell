//
//  Tab.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/08.
//

import SwiftUI

enum Tab: Int, CaseIterable {
    case repoSearch
    case userSearch

    init(tag: Int) {
        switch tag {
        case Tab.repoSearch.rawValue:
            self = .repoSearch
        case Tab.userSearch.rawValue:
            self = .userSearch
        default:
            self = .repoSearch
        }
    }

    @ViewBuilder
    func contentView(tabViewModel: TabViewModel) -> some View {
        switch self {
        case .repoSearch:
            NavigationStack {
                GitHubRepoSearchScreenView(viewModel: .init(), dismissSearchTrigger: false)
                    .environmentObject(tabViewModel)
            }
            .tabItem {
                Label("RepoSearch", systemImage: "1.circle")
            }
            .tag(self.rawValue)
        case .userSearch:
            NavigationStack {
                GitHubUserSearchScreenView(viewModel: .init(), dismissSearchTrigger: false)
                    .environmentObject(tabViewModel)
            }
            .tabItem {
                Label("UserSearch", systemImage: "2.circle")
            }
            .tag(self.rawValue)
        }
    }
}
