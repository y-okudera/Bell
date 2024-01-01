//
//  GitHubRepoRepository.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Combine
import Domain
import Foundation
import GraphQL

public protocol GitHubRepoRepository {
    func listGitHubRepo(input: GitHubRepoFilterInput) -> Future<GitHub.ListRepoQuery.Data, Domain.GraphQLError>
}
