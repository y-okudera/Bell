//
//  GitHubUserPresenter.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import GraphQL
import GraphQL_Domain
import GraphQL_Usecase

public struct GitHubUserPresenter: GraphQL_Usecase.GitHubUserPresenter {
    public init() {}
    public func responseList(data: GitHub.SearchQuery.Data) -> GitHubUserConnection {
        .init(data)
    }
}
