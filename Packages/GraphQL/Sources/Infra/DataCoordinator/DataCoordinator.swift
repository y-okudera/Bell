//
//  DataCoordinator.swift
//  
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Apollo
import Foundation

enum DataCoordinator {
    static let gitHubApiApolloClient: ApolloClient = {
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let authPayloads = ["Authorization": "Bearer " + Env.gitHubAccessToken]
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = authPayloads
        let client = URLSessionClient(sessionConfiguration: configuration, callbackQueue: nil)
        let provider = NetworkInterceptorProvider(store: store, client: client)
        let url = URL(string: "https://api.github.com/graphql")!
        let requestChainTransport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)
        return ApolloClient(networkTransport: requestChainTransport, store: store)
    }()
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
