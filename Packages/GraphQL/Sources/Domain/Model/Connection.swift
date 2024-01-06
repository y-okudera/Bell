//
//  Connection.swift
//
//
//  Created by Yuki Okudera on 2024/01/06.
//

import Foundation

public class Connection<T> {
    public let edges: [Edge<T>]
    public let pageInfo: PageInfo
    public let totalCount: Int

    public init(
        edges: [Edge<T>],
        pageInfo: PageInfo,
        totalCount: Int
    ) {
        self.edges = edges
        self.pageInfo = pageInfo
        self.totalCount = totalCount
    }
}

public class Edge<T> {
    public let cursor: String
    public let node: T

    public init(cursor: String, node: T) {
        self.cursor = cursor
        self.node = node
    }
}

public protocol Node: Identifiable, Equatable {}

/// Search.PageInfo
///
/// Parent Type: `PageInfo`
public struct PageInfo {
    /// When paginating forwards, the cursor to continue.
    public let endCursor: String?
    /// When paginating forwards, are there more items?
    public let hasNextPage: Bool
    /// When paginating backwards, are there more items?
    public let hasPreviousPage: Bool
    /// When paginating backwards, the cursor to continue.
    public let startCursor: String?

    public init(
        endCursor: String?,
        hasNextPage: Bool,
        hasPreviousPage: Bool,
        startCursor: String?
    ) {
        self.endCursor = endCursor
        self.hasNextPage = hasNextPage
        self.hasPreviousPage = hasPreviousPage
        self.startCursor = startCursor
    }
}
