//
//  GitHubRepoController.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Combine
import Foundation
import GraphQL_Dependency
import GraphQL_Domain
import GraphQL_Usecase

public protocol GitHubRepoController {
    func listGitHubRepo(input: GitHubRepoFilterInput) -> AnyPublisher<GitHubRepoConnection, GraphQLError>
}

public struct GitHubRepoControllerImpl: GitHubRepoController {

    @Inject
    var gitHubRepoService: GitHubRepoService

    public init() {}

    public func listGitHubRepo(input: GitHubRepoFilterInput) -> AnyPublisher<GitHubRepoConnection, GraphQLError> {
        self.gitHubRepoService.listGitHubRepo(input: input)
    }
}
