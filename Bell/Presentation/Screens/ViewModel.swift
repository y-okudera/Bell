//
//  ViewModel.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/02.
//

import Combine
import Foundation
import GraphQL_Dependency
import GraphQL_Interface

final class ViewModel: ObservableObject {
    var cancellable: AnyCancellable?

    lazy var c: GitHubRepoController = DependencyContainer.shared.resolve(key: InjectionKey.gitHubRepoController.capitalized)

    func searchGitHubRepo() {
        // FIXME: testing call api.
        cancellable = c.listGitHubRepo(input: .init(after: nil, before: nil, first: 10, last: nil, query: "Swift"))
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                }
            } receiveValue: { value in
                print("pageInfo.hasPreviousPage", value.pageInfo.hasPreviousPage)
                print("pageInfo.hasNextPage", value.pageInfo.hasNextPage)
                print("repositoryCount", value.repositoryCount, "\n")
                value.edges.forEach {
                    if let node = $0?.node {
                        print(node, "\n")
                    }
                }
            }
    }
}
