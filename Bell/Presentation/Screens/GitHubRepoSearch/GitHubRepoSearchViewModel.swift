//
//  GitHubRepoSearchViewModel.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/02.
//

import Combine
import Foundation
import GraphQL_Dependency
import GraphQL_Domain
import GraphQL_Interface

final class GitHubRepoSearchViewModel: ObservableObject {
    private var cancellable: AnyCancellable?
    private lazy var gitHubRepoController: GitHubRepoController = DependencyContainer.shared.resolve(key: InjectionKey.gitHubRepoController.capitalized)

    @Published private(set) var searchText: String = ""
    @Published private(set) var didSearchText: String = ""
    @Published private(set) var dismissSearch: Bool = false
    @Published private(set) var data: [GitHubRepoListResponse.Edge.Node] = []
    @Published private(set) var hasNextPage: Bool = false
    @Published private(set) var repositoryCount: Int = 0

    var navigationTitle: String {
        self.didSearchText.isEmpty ? "Repositories" : "\(self.didSearchText) \(String.localizedStringWithFormat("%d", self.repositoryCount))件"
    }

    func searchBarTextDidChange(to text: String) {
        self.searchText = text
    }

    func onSubmitSearch() {
        dismissSearch = false
        let input = GitHubRepoFilterInput(after: nil, before: nil, first: 10, last: nil, query: self.searchText)
        self.cancellable = self.gitHubRepoController.listGitHubRepo(input: input)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                    self.didSearchText = self.searchText
                    self.dismissSearch = true
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                }
            } receiveValue: { value in
                self.hasNextPage = value.pageInfo.hasNextPage
                self.repositoryCount = value.repositoryCount
                self.data = value.edges.compactMap { $0?.node }
            }
    }
}
