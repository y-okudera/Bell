//
//  GitHubUserPresenter.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Foundation
import GraphQL
import GraphQL_Domain

public protocol GitHubUserPresenter {
    func responseList(data: GitHub.SearchQuery.Data) -> GitHubUserConnection
}
