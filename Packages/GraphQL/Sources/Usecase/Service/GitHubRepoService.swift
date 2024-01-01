//
//  GitHubRepoService.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Combine
import Domain
import Foundation

public protocol GitHubRepoService {
    var gitHubRepoRepository: GitHubRepoRepository { get }
    var gitHubRepoPresenter: GitHubRepoPresenter { get }

    func listGitHubRepo(input: GitHubRepoFilterInput) -> AnyPublisher<GitHubRepoListResponse, GraphQLError>
}

struct GitHubRepoServiceImpl: GitHubRepoService {
    let gitHubRepoRepository: GitHubRepoRepository
    let gitHubRepoPresenter: GitHubRepoPresenter

    init(gitHubRepoRepository: GitHubRepoRepository, gitHubRepoPresenter: GitHubRepoPresenter) {
        self.gitHubRepoRepository = gitHubRepoRepository
        self.gitHubRepoPresenter = gitHubRepoPresenter
    }

    func listGitHubRepo(input: GitHubRepoFilterInput) -> AnyPublisher<GitHubRepoListResponse, GraphQLError> {
        self.gitHubRepoRepository.listGitHubRepo(input: input)
            .map { gitHubRepoPresenter.responseList(data: $0) }
            .eraseToAnyPublisher()
    }
}

