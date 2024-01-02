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
import GraphQL_Usecase

public struct GitHubRepoRepository: GraphQL_Usecase.GitHubRepoRepository {
    public init() {}
    public func listGitHubRepo(input: GitHubRepoFilterInput) -> Future<GitHub.ListRepoQuery.Data, GraphQLError> {
        let query = GitHub.ListRepoQuery(
            after: input.after != nil ? GraphQLNullable<String>.some(input.after!) : GraphQLNullable<String>.null,
            before: input.before != nil ? GraphQLNullable<String>.some(input.before!) : GraphQLNullable<String>.null,
            first: input.first != nil ? GraphQLNullable<Int>.some(input.first!) : GraphQLNullable<Int>.null,
            last: input.last != nil ? GraphQLNullable<Int>.some(input.last!) : GraphQLNullable<Int>.null,
            query: input.query
        )
        return DataCoordinator.gitHubApiClient.fetch(query: query)
    }
}
