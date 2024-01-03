//
//  GitHubRepoFilterInput.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Foundation

public struct GitHubRepoFilterInput {
    public let after: String?
    public let first: Int?
    public let query: String

    public init(after: String?, first: Int?, query: String) {
        self.after = after
        self.first = first
        self.query = query
    }
}
