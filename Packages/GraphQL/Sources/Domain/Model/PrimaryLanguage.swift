//
//  PrimaryLanguage.swift
//  
//
//  Created by Yuki Okudera on 2024/01/13.
//

import Foundation

/// Search.Edge.Node.AsRepository.PrimaryLanguage
///
/// Parent Type: `Language`
public struct PrimaryLanguage: Node {
    /// The Node ID of the Language object
    public let id: String
    /// The name of the current language.
    public let name: String
    /// The color defined for the current language.
    public let color: String?

    public init(
        id: String,
        name: String,
        color: String?
    ) {
        self.id = id
        self.name = name
        self.color = color
    }
}
