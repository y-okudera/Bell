//
//  GitHubUserLoadingState.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/08.
//

import GraphQL_Domain

enum GitHubUserLoadingState: Equatable {
    case idle
    case initialLoading
    case emptyState
    case loaded(data: [GitHubUser], isAdditionalLoading: Bool)
}
