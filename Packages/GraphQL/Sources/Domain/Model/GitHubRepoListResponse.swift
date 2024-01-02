//
//  GitHubRepoListResponse.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Foundation

public struct GitHubRepoListResponse {
    /// The total number of pieces of code that matched the search query. Regardless
    /// of the total number of matches, a maximum of 1,000 results will be available
    /// across all types.
    public let codeCount: Int
    /// The total number of discussions that matched the search query. Regardless of
    /// the total number of matches, a maximum of 1,000 results will be available
    /// across all types.
    public let discussionCount: Int
    /// A list of edges.
    public let edges: [Edge?]
    /// The total number of issues that matched the search query. Regardless of the
    /// total number of matches, a maximum of 1,000 results will be available across all types.
    public let issueCount: Int
    /// Information to aid in pagination.
    public let pageInfo: PageInfo
    /// The total number of repositories that matched the search query. Regardless of
    /// the total number of matches, a maximum of 1,000 results will be available
    /// across all types.
    public let repositoryCount: Int
    /// The total number of users that matched the search query. Regardless of the
    /// total number of matches, a maximum of 1,000 results will be available across all types.
    public let userCount: Int
    /// The total number of wiki pages that matched the search query. Regardless of
    /// the total number of matches, a maximum of 1,000 results will be available
    /// across all types.
    public let wikiCount: Int

    public init(
        codeCount: Int,
        discussionCount: Int,
        edges: [Edge?],
        issueCount: Int,
        pageInfo: PageInfo,
        repositoryCount: Int,
        userCount: Int,
        wikiCount: Int
    ) {
        self.codeCount = codeCount
        self.discussionCount = discussionCount
        self.edges = edges
        self.issueCount = issueCount
        self.pageInfo = pageInfo
        self.repositoryCount = repositoryCount
        self.userCount = userCount
        self.wikiCount = wikiCount
    }
}

extension GitHubRepoListResponse {
    /// Search.Edge
    ///
    /// Parent Type: `SearchResultItemEdge`
    public struct Edge {
        /// A cursor for use in pagination.
        public let cursor: String
        /// The item at the end of the edge.
        public let node: Node?

        public init(cursor: String, node: Node?) {
            self.cursor = cursor
            self.node = node
        }
    }
}

extension GitHubRepoListResponse.Edge {
    /// Search.Edge.Node
    ///
    /// Parent Type: `SearchResultItem`
    public struct Node: Hashable {
        /// The description of the repository.
        public let description: String?
        /// The repository's URL.
        public let homepageUrl: URL?
        /// The repository's name with owner.
        public let nameWithOwner: String
        /// The User owner of the repository.
        public let owner: Owner
        /// A list of users who have starred this starrable.
        public let stargazers: Stargazers
        /// The primary language of the repository's code.
        public let primaryLanguage: PrimaryLanguage?

        public init(
            description: String?,
            homepageUrl: URL?,
            nameWithOwner: String,
            owner: Owner,
            stargazers: Stargazers,
            primaryLanguage: PrimaryLanguage?
        ) {
            self.description = description
            self.homepageUrl = homepageUrl
            self.nameWithOwner = nameWithOwner
            self.owner = owner
            self.stargazers = stargazers
            self.primaryLanguage = primaryLanguage
        }
    }
}

extension GitHubRepoListResponse.Edge.Node {
    /// Search.Edge.Node.AsRepository.Owner
    ///
    /// Parent Type: `RepositoryOwner`
    public struct Owner: Hashable {
        /// A URL pointing to the owner's public avatar.
        public let avatarUrl: URL?

        public init(avatarUrl: URL?) {
            self.avatarUrl = avatarUrl
        }
    }

    /// Search.Edge.Node.AsRepository.Stargazers
    ///
    /// Parent Type: `StargazerConnection`
    public struct Stargazers: Hashable {
        /// Identifies the total count of items in the connection.
        public let totalCount: Int

        public init(totalCount: Int) {
            self.totalCount = totalCount
        }
    }

    /// Search.Edge.Node.AsRepository.PrimaryLanguage
    ///
    /// Parent Type: `Language`
    public struct PrimaryLanguage: Hashable {
        /// The name of the current language.
        public let name: String

        public init(name: String) {
            self.name = name
        }
    }
}

/// Search.PageInfo
///
/// Parent Type: `PageInfo`
public struct PageInfo {
    /// When paginating forwards, the cursor to continue.
    public let endCursor: String?
    /// When paginating forwards, are there more items?
    public let hasNextPage: Bool
    /// When paginating backwards, are there more items?
    public let hasPreviousPage: Bool
    /// When paginating backwards, the cursor to continue.
    public let startCursor: String?

    public init(endCursor: String?, hasNextPage: Bool, hasPreviousPage: Bool, startCursor: String?) {
        self.endCursor = endCursor
        self.hasNextPage = hasNextPage
        self.hasPreviousPage = hasPreviousPage
        self.startCursor = startCursor
    }
}
