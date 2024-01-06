//
//  GitHubRepoPresenter.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Foundation
import GraphQL
import GraphQL_Domain

public protocol GitHubRepoPresenter {
    func responseList(data: GitHub.SearchQuery.Data) -> GitHubRepoConnection
}
