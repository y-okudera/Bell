//
//  GitHubRepoService.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Combine
import GraphQL_Dependency
import GraphQL_Domain
import Foundation

public protocol GitHubRepoService {
    func listGitHubRepo(input: GitHubRepoFilterInput) -> AnyPublisher<GitHubRepoListResponse, GraphQLError>
}

public struct GitHubRepoServiceImpl: GitHubRepoService {
    
    @Inject
    var gitHubRepoRepository: GitHubRepoRepository
    
    @Inject
    var gitHubRepoPresenter: GitHubRepoPresenter
    
    public init() {}
    
    public func listGitHubRepo(input: GitHubRepoFilterInput) -> AnyPublisher<GitHubRepoListResponse, GraphQLError> {
        self.gitHubRepoRepository.listGitHubRepo(input: input)
            .map { gitHubRepoPresenter.responseList(data: $0) }
            .eraseToAnyPublisher()
    }
}
