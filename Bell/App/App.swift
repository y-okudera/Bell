//
//  App.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/01.
//

import SwiftUI

@main
struct App: SwiftUI.App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var selection = 1

    var body: some Scene {
        WindowGroup {
            TabView {
                GitHubRepoSearchScreenView()
                    .tabItem {
                        Label("RepoSearch", systemImage: "1.circle")
                    }
                    .tag(1)
                GitHubUserSearchScreenView()
                    .tabItem {
                        Label("UserSearch", systemImage: "2.circle")
                    }
                    .tag(2)
            }
        }
    }
}
