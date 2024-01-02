//
//  GitHubRepoController.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Combine
import GraphQL_Dependency
import Domain
import Foundation
import GraphQL_Usecase

public protocol GitHubRepoController {
    func listGitHubRepo(input: GitHubRepoFilterInput) -> AnyPublisher<GitHubRepoListResponse, GraphQLError>
}

public struct GitHubRepoControllerImpl: GitHubRepoController {

    @Inject
    var gitHubRepoService: GitHubRepoService

    public init() {}

    public func listGitHubRepo(input: GitHubRepoFilterInput) -> AnyPublisher<GitHubRepoListResponse, GraphQLError> {
        self.gitHubRepoService.listGitHubRepo(input: input)
    }
}
