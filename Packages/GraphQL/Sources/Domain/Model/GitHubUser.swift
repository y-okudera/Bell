//
//  GitHubUser.swift
//
//
//  Created by Yuki Okudera on 2024/01/13.
//

import Foundation

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
