//
//  AppDelegate.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/02.
//

import GraphQL_Dependency
import GraphQL_Infra
import GraphQL_Interface
import GraphQL_Usecase
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        self.inject()
        return true
    }

    private func inject() {
        DependencyContainer.shared.register(key: InjectionKey.gitHubRepoRepository.capitalized) {
            GitHubRepoRepository()
        }
        DependencyContainer.shared.register(key: InjectionKey.gitHubRepoPresenter.capitalized) {
            GitHubRepoPresenter()
        }
        DependencyContainer.shared.register(key: InjectionKey.gitHubRepoService.capitalized) {
            GitHubRepoServiceImpl()
        }
        DependencyContainer.shared.register(key: InjectionKey.gitHubRepoController.capitalized) {
            GitHubRepoControllerImpl()
        }
    }
}
