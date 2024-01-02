//
//  InjectionKey.swift
//
//
//  Created by Yuki Okudera on 2024/01/02.
//

import Foundation

public enum InjectionKey: String {
    case gitHubRepoRepository
    case gitHubRepoPresenter
    case gitHubRepoService
    case gitHubRepoController

    public var capitalized: String {
        self.rawValue.prefix(1).uppercased() + self.rawValue.dropFirst()
    }
}
