//
//  GitHubRepoLoadingState.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/08.
//

import GraphQL_Domain

enum GitHubRepoLoadingState: Equatable {
    case idle
    case initialLoading
    case emptyState
    case loaded(data: [GitHubRepo], isAdditionalLoading: Bool)
}
