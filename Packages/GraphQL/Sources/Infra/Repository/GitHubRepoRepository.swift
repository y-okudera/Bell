//
//  GitHubRepoRepository.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Apollo
import Combine
import Domain
import Foundation
import GraphQL
import Usecase

struct GitHubRepoRepository: Usecase.GitHubRepoRepository {
    func listGitHubRepo(input: GitHubRepoFilterInput) -> Future<GitHub.ListRepoQuery.Data, Domain.GraphQLError> {
        let query = GitHub.ListRepoQuery(
            after: input.after != nil ? GraphQLNullable<String>.some(input.after!) : GraphQLNullable<String>.null,
            before: input.before != nil ? GraphQLNullable<String>.some(input.before!) : GraphQLNullable<String>.null,
            first: input.first != nil ? GraphQLNullable<Int>.some(input.first!) : GraphQLNullable<Int>.null,
            last: input.last != nil ? GraphQLNullable<Int>.some(input.last!) : GraphQLNullable<Int>.null,
            query: input.query
        )
        return Future() { promise in
            DataCoordinator.gitHubApiApolloClient.fetch(query: query) { result in
                switch result {
                case .success(let gqlResult):
                    if let data = gqlResult.data {
                        promise(.success(data))
                    } else if let errors = gqlResult.errors {
                        // GraphQL errors
                        promise(.failure(.gqlError(errors: errors)))
                    } else {
                        // unknown error
                        promise(.failure(.unknownError))
                    }
                case .failure(let err):
                    // Network or response format errors
                    promise(.failure(.networkError(error: err)))
                }
            }
        }
    }
}
