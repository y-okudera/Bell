//
//  DomainModel+Init.swift
//
//
//  Created by Yuki Okudera on 2024/01/13.
//

import GraphQL
import GraphQL_Domain

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
            node: .init(data.node?.asRepository?.fragments.repositoryFragment)
        )
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
            node: .init(data.node?.asUser?.fragments.userFragment)
        )
    }
}

extension GitHubRepo {
    init(_ data: GitHub.RepositoryFragment?) {
        self.init(
            id: data?.id ?? "",
            url: .init(string: data?.url ?? ""),
            description: data?.description,
            homepageUrl: .init(string: data?.homepageUrl ?? ""),
            nameWithOwner: data?.nameWithOwner ?? "",
            owner: .init(data?.owner.asUser?.fragments.userFragment),
            stargazerCount: data?.stargazerCount ?? 0,
            primaryLanguage: .init(data?.primaryLanguage?.fragments.languageFragment)
        )
    }
}

extension GitHubUser {
    init(_ data: GitHub.UserFragment?) {
        self.init(
            id: data?.id ?? "",
            avatarUrl: .init(string: data?.avatarUrl ?? ""),
            login: data?.login ?? "",
            resourcePath: .init(string: data?.resourcePath ?? ""),
            url: .init(string: data?.url ?? "")
        )
    }
}

extension PrimaryLanguage {
    init(_ data: GitHub.LanguageFragment?) {
        self = .init(
            id: data?.id ?? "",
            name: data?.name ?? "",
            color: data?.color
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
