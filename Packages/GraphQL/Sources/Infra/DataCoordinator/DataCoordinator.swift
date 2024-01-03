//
//  DataCoordinator.swift
//  
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Apollo
import ApolloAPI
import Combine
import Foundation
import GraphQL_Domain

final class DataCoordinator {

    static let gitHubApiClient: DataCoordinator = {
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let authPayloads = ["Authorization": "Bearer " + Env.gitHubAccessToken]
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = authPayloads
        configuration.timeoutIntervalForRequest = 30
        let client = URLSessionClient(sessionConfiguration: configuration, callbackQueue: nil)
        let provider = NetworkInterceptorProvider(store: store, client: client)
        let url = URL(string: "https://api.github.com/graphql")!
        let requestChainTransport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)
        return .init(apolloClient: ApolloClient(networkTransport: requestChainTransport, store: store))
    }()

    let apolloClient: ApolloClient

    private init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }

    func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .default,
        contextIdentifier: UUID? = nil,
        context: RequestContext? = nil,
        queue: DispatchQueue = .main
    ) -> Future<Query.Data, GraphQL_Domain.GraphQLError> {
        return Future() { promise in
            self.apolloClient.fetch(query: query) { result in
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

private struct NetworkInterceptorProvider: InterceptorProvider {
    // These properties will remain the same throughout the life of the `InterceptorProvider`, even though they
    // will be handed to different interceptors.
    private let store: ApolloStore
    private let client: URLSessionClient

    init(
        store: ApolloStore,
        client: URLSessionClient
    ) {
        self.store = store
        self.client = client
    }

    func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] {
        return [
            MaxRetryInterceptor(),
            CacheReadInterceptor(store: self.store),
            NetworkFetchInterceptor(client: self.client),
            ResponseCodeInterceptor(),
            JSONResponseParsingInterceptor(),
            AutomaticPersistedQueryInterceptor(),
            CacheWriteInterceptor(store: self.store)
        ]
    }
}
