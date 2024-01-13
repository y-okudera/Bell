//
//  GitHubRepoPresenter.swift
//  
//
//  Created by Yuki Okudera on 2024/01/01.
//

import GraphQL
import GraphQL_Domain
import GraphQL_Usecase

public struct GitHubRepoPresenter: GraphQL_Usecase.GitHubRepoPresenter {
    public init() {}
    public func responseList(data: GitHub.SearchQuery.Data) -> GitHubRepoConnection {
        .init(data)
    }
}
