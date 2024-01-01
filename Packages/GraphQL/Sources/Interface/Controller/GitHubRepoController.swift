//
//  GitHubRepoController.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Combine
import Domain
import Foundation
import Usecase

protocol GitHubRepoController {
    var gitHubRepoService: GitHubRepoService { get }

    func listGitHubRepo(input: GitHubRepoFilterInput) -> AnyPublisher<GitHubRepoListResponse, GraphQLError>
}

struct GitHubRepoControllerImpl: GitHubRepoController {
    let gitHubRepoService: GitHubRepoService

    init(gitHubRepoService: GitHubRepoService) {
        self.gitHubRepoService = gitHubRepoService
    }

    func listGitHubRepo(input: GitHubRepoFilterInput) -> AnyPublisher<GitHubRepoListResponse, GraphQLError> {
        gitHubRepoService.listGitHubRepo(input: input)
    }
}
