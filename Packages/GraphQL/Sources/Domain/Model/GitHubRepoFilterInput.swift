//
//  GitHubRepoFilterInput.swift
//
//
//  Created by Yuki Okudera on 2024/01/01.
//

import Foundation

public struct GitHubRepoFilterInput {
    public let after: String?
    public let before: String?
    public let first: Int?
    public let last: Int?
    public let query: String

    public init(after: String?, before: String?, first: Int?, last: Int?, query: String) {
        self.after = after
        self.before = before
        self.first = first
        self.last = last
        self.query = query
    }
}
