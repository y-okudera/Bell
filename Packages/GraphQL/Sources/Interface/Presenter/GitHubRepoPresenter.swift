//
//  GitHubRepoPresenter.swift
//  
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Domain
import Foundation
import GraphQL
import Usecase

struct GitHubRepoPresenter: Usecase.GitHubRepoPresenter {
    func responseList(data: GitHub.ListRepoQuery.Data) -> GitHubRepoListResponse {
        .init(data)
    }
}

extension GitHubRepoListResponse {
    init(_ data: GitHub.ListRepoQuery.Data) {
        self = .init(
            codeCount: data.search.codeCount,
            discussionCount: data.search.discussionCount,
            edges: (data.search.edges ?? []).compactMap { .init($0) },
            issueCount: data.search.issueCount,
            pageInfo: .init(data.search.pageInfo),
            repositoryCount: data.search.repositoryCount,
            userCount: data.search.userCount,
            wikiCount: data.search.wikiCount
        )
    }
}

extension GitHubRepoListResponse.Edge {
    init(_ data: GitHub.ListRepoQuery.Data.Search.Edge?) {
        self = .init(
            cursor: data?.cursor ?? "",
            node: .init(data?.node)
        )
    }
}

extension GitHubRepoListResponse.Edge.Node {
    init(_ data: GitHub.ListRepoQuery.Data.Search.Edge.Node?) {
        self = .init(
            description: data?.asRepository?.description,
            homepageUrl: URL(string: data?.asRepository?.homepageUrl ?? ""),
            nameWithOwner: data?.asRepository?.nameWithOwner ?? "",
            owner: .init(data?.asRepository?.owner),
            stargazers: .init(data?.asRepository?.stargazers),
            primaryLanguage: .init(data?.asRepository?.primaryLanguage)
        )
    }
}

extension GitHubRepoListResponse.Edge.Node.Owner {
    init(_ data: GitHub.ListRepoQuery.Data.Search.Edge.Node.AsRepository.Owner?) {
        self = .init(avatarUrl: .init(string: data?.avatarUrl ?? ""))
    }
}

extension GitHubRepoListResponse.Edge.Node.Stargazers {
    init(_ data: GitHub.ListRepoQuery.Data.Search.Edge.Node.AsRepository.Stargazers?) {
        self = .init(totalCount: data?.totalCount ?? 0)
    }
}

extension GitHubRepoListResponse.Edge.Node.PrimaryLanguage {
    init(_ data: GitHub.ListRepoQuery.Data.Search.Edge.Node.AsRepository.PrimaryLanguage?) {
        self = .init(name: data?.name ?? "")
    }
}

extension PageInfo {
    init(_ data: GitHub.ListRepoQuery.Data.Search.PageInfo?) {
        self = .init(
            endCursor: data?.endCursor,
            hasNextPage: data?.hasNextPage ?? false,
            hasPreviousPage: data?.hasPreviousPage ?? false,
            startCursor: data?.startCursor
        )
    }
}
