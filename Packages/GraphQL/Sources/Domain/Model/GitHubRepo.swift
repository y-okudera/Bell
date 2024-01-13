//
//  GitHubRepo.swift
//
//
//  Created by Yuki Okudera on 2024/01/13.
//

import Foundation

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
