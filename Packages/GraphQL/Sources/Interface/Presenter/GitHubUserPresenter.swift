//
//  GitHubUserPresenter.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Foundation
import GraphQL
import GraphQL_Domain
import GraphQL_Usecase

public struct GitHubUserPresenter: GraphQL_Usecase.GitHubUserPresenter {
    public init() {}
    public func responseList(data: GitHub.SearchQuery.Data) -> GitHubUserConnection {
        .init(data)
    }
}

extension GitHubUserConnection {
    convenience init(_ data: GitHub.SearchQuery.Data) {
        self.init(
            edges: (data.search.edges ?? []).compactMap { $0 }.map { .init($0) },
            pageInfo: .init(data.search.pageInfo),
            totalCount: data.search.userCount
        )
    }
}

extension Edge<GitHubUser> {
    convenience init(_ data: GitHub.SearchQuery.Data.Search.Edge) {
        self.init(
            cursor: data.cursor,
            node: .init(data.node)
        )
    }
}

extension GitHubUser {
    init(_ data: GitHub.SearchQuery.Data.Search.Edge.Node?) {
        self.init(
            id: data?.asUser?.id ?? "",
            avatarUrl: URL(string: data?.asUser?.avatarUrl ?? ""),
            login: data?.asUser?.login ?? "",
            resourcePath: URL(string: data?.asUser?.resourcePath ?? ""),
            url: URL(string: data?.asUser?.url ?? "")
        )
    }
}
