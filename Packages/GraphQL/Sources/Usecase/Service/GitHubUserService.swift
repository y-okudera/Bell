//
//  GitHubUserService.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Combine
import GraphQL_Dependency
import GraphQL_Domain
import Foundation

public protocol GitHubUserService {
    func listGitHubUser(input: GitHubSearchFilterInput) -> AnyPublisher<GitHubUserConnection, GraphQLError>
}

public struct GitHubUserServiceImpl: GitHubUserService {

    @Inject
    var gitHubUserRepository: GitHubUserRepository

    @Inject
    var gitHubUserPresenter: GitHubUserPresenter

    public init() {}

    public func listGitHubUser(input: GitHubSearchFilterInput) -> AnyPublisher<GitHubUserConnection, GraphQLError> {
        self.gitHubUserRepository.listGitHubUser(input: input)
            .map { gitHubUserPresenter.responseList(data: $0) }
            .eraseToAnyPublisher()
    }
}
