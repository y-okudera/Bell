//
//  GitHubRepoConnection.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Foundation

public final class GitHubRepoConnection: Connection<GitHubRepo> {}

public struct GitHubRepo: Node {
    /// The Node ID of the Repository object
    public let id: String
    /// The HTTP URL for this repository
    public let url: URL?
    /// The description of the repository.
    public let description: String?
    /// The repository's URL.
    public let homepageUrl: URL?
    /// The repository's name with owner.
    public let nameWithOwner: String
    /// The User owner of the repository.
    public let owner: GitHubUser
    /// Returns a count of how many stargazers there are on this object
    public let stargazerCount: Int
    /// The primary language of the repository's code.
    public let primaryLanguage: PrimaryLanguage?

    public init(
        id: String,
        url: URL?,
        description: String?,
        homepageUrl: URL?,
        nameWithOwner: String,
        owner: GitHubUser,
        stargazerCount: Int,
        primaryLanguage: PrimaryLanguage?
    ) {
        self.id = id
        self.url = url
        self.description = description
        self.homepageUrl = homepageUrl
        self.nameWithOwner = nameWithOwner
        self.owner = owner
        self.stargazerCount = stargazerCount
        self.primaryLanguage = primaryLanguage
    }
}

/// Search.Edge.Node.AsRepository.Owner
///
/// Parent Type: `RepositoryOwner`
public struct GitHubUser: Node {
    /// The Node ID of the RepositoryOwner object
    public let id: String
    /// A URL pointing to the owner's public avatar.
    public let avatarUrl: URL?
    /// The username used to login.
    public let login: String
    /// The HTTP URL for the owner.
    public let resourcePath: URL?
    /// The HTTP URL for the owner.
    public let url: URL?

    public init(
        id: String,
        avatarUrl: URL?,
        login: String,
        resourcePath: URL?,
        url: URL?
    ) {
        self.id = id
        self.avatarUrl = avatarUrl
        self.login = login
        self.resourcePath = resourcePath
        self.url = url
    }
}

/// Search.Edge.Node.AsRepository.PrimaryLanguage
///
/// Parent Type: `Language`
public struct PrimaryLanguage: Node {
    /// The Node ID of the Language object
    public let id: String
    /// The name of the current language.
    public let name: String
    /// The color defined for the current language.
    public let color: String?

    public init(
        id: String,
        name: String,
        color: String?
    ) {
        self.id = id
        self.name = name
        self.color = color
    }
}
