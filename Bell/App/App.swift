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

    var body: some Scene {
        WindowGroup {
            GitHubRepoSearchScreenView()
        }
    }
}
