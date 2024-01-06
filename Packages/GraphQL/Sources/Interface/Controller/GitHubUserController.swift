//
//  GitHubUserController.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Combine
import Foundation
import GraphQL_Dependency
import GraphQL_Domain
import GraphQL_Usecase

public protocol GitHubUserController {
    func listGitHubUser(input: GitHubSearchFilterInput) -> AnyPublisher<GitHubUserConnection, GraphQLError>
}

public struct GitHubUserControllerImpl: GitHubUserController {

    @Inject
    var gitHubUserService: GitHubUserService

    public init() {}

    public func listGitHubUser(input: GitHubSearchFilterInput) -> AnyPublisher<GitHubUserConnection, GraphQLError> {
        self.gitHubUserService.listGitHubUser(input: input)
    }
}
