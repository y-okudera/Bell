//
//  GitHubUserRepository.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Combine
import Foundation
import GraphQL
import GraphQL_Domain

public protocol GitHubUserRepository {
    func listGitHubUser(input: GitHubSearchFilterInput) -> Future<GitHub.SearchQuery.Data, GraphQL_Domain.GraphQLError>
}
