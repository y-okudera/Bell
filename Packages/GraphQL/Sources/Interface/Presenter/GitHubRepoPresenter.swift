//
//  GitHubRepoPresenter.swift
//  
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Foundation
import GraphQL
import GraphQL_Domain
import GraphQL_Usecase

public struct GitHubRepoPresenter: GraphQL_Usecase.GitHubRepoPresenter {
    public init() {}
    public func responseList(data: GitHub.SearchQuery.Data) -> GitHubRepoConnection {
        .init(data)
    }
}

extension GitHubRepoConnection {
    convenience init(_ data: GitHub.SearchQuery.Data) {
        self.init(
            edges: (data.search.edges ?? []).compactMap { $0 }.map { .init($0) },
            pageInfo: .init(data.search.pageInfo),
            totalCount: data.search.repositoryCount
        )
    }
}

extension Edge<GitHubRepo> {
    convenience init(_ data: GitHub.SearchQuery.Data.Search.Edge) {
        self.init(
            cursor: data.cursor,
            node: .init(data.node)
        )
    }
}

extension GitHubRepo {
    init(_ data: GitHub.SearchQuery.Data.Search.Edge.Node?) {
        self.init(
            id: data?.asRepository?.id ?? "",
            url: URL(string: data?.asRepository?.url ?? ""),
            description: data?.asRepository?.description,
            homepageUrl: URL(string: data?.asRepository?.homepageUrl ?? ""),
            nameWithOwner: data?.asRepository?.nameWithOwner ?? "",
            owner: .init(data?.asRepository?.owner),
            stargazerCount: data?.asRepository?.stargazerCount ?? 0,
            primaryLanguage: .init(data?.asRepository?.primaryLanguage)
        )
    }
}

extension GitHubUser {
    init(_ data: GitHub.SearchQuery.Data.Search.Edge.Node.AsRepository.Owner?) {
        self.init(
            id: data?.id ?? "",
            avatarUrl: URL(string: data?.avatarUrl ?? ""),
            login: data?.login ?? "",
            resourcePath: URL(string: data?.resourcePath ?? ""),
            url: URL(string: data?.url ?? "")
        )
    }
}

extension PrimaryLanguage {
    init?(_ data: GitHub.SearchQuery.Data.Search.Edge.Node.AsRepository.PrimaryLanguage?) {
        guard let primaryLanguage = data else {
            return nil
        }
        self.init(
            id: primaryLanguage.id,
            name: primaryLanguage.name,
            color: primaryLanguage.color
        )
    }
}

extension PageInfo {
    init(_ data: GitHub.SearchQuery.Data.Search.PageInfo?) {
        self = .init(
            endCursor: data?.endCursor,
            hasNextPage: data?.hasNextPage ?? false,
            hasPreviousPage: data?.hasPreviousPage ?? false,
            startCursor: data?.startCursor
        )
    }
}
