//
//  GitHubRepoRepository.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Combine
import Foundation
import GraphQL
import GraphQL_Domain
import GraphQL_Usecase

public struct GitHubRepoRepository: GraphQL_Usecase.GitHubRepoRepository {
    public init() {}
    public func listGitHubRepo(input: GitHubSearchFilterInput) -> Future<GitHub.SearchQuery.Data, GraphQLError> {
        let query = GitHub.SearchQuery(
            after: input.after != nil ? GraphQLNullable<String>.some(input.after!) : GraphQLNullable<String>.null,
            first: input.first != nil ? GraphQLNullable<Int>.some(input.first!) : GraphQLNullable<Int>.null,
            query: input.query,
            searchType: .case(.repository)
        )
        return DataCoordinator.gitHubApiClient.fetch(query: query)
    }
}
