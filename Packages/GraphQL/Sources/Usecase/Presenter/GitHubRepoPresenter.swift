//
//  GitHubRepoPresenter.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Domain
import Foundation
import GraphQL

public protocol GitHubRepoPresenter {
    func responseList(data: GitHub.ListRepoQuery.Data) -> GitHubRepoListResponse
}
