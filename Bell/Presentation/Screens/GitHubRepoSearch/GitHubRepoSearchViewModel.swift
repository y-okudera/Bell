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
    @Published private(set) var dialog: Dialog?

    var navigationTitle: String {
        self.didSearchText.isEmpty ? "Repositories" : "\(self.didSearchText) \(String.localizedStringWithFormat("%d", self.repositoryCount))件"
    }

    func searchBarTextDidChange(to text: String) {
        self.searchText = text
    }

    func dialogDidChange(to dialog: Dialog?) {
        self.dialog = dialog
    }

    func onSubmitSearch() {
        dismissSearch = false
        let input = GitHubRepoFilterInput(after: nil, before: nil, first: 10, last: nil, query: self.searchText)
        self.cancellable = self.gitHubRepoController.listGitHubRepo(input: input)
            .sink { completion in
                switch completion {
                case .finished:
                    self.didSearchText = self.searchText
                    self.dismissSearch = true
                case .failure(let error):
                    switch error {
                    case .gqlError(errors: let errors):
                        logger.error("\(errors)")
                        self.dialog = .alert(viewData: .init(
                            title: "Failed to Search Repository",
                            message: "A GraphQL error has occurred.\n\n" + errors.map { $0.localizedDescription }.joined(separator: "\n\n"),
                            buttonText: "Close",
                            handler: nil
                        ))
                    case .networkError(error: let error):
                        logger.error("\(error)")
                        self.dialog = .confirm(viewData: .init(
                            title: "Failed to Search Repository",
                            message: "Please check your network connection and try again.",
                            primaryButtonText: "Retry",
                            secondaryButtonText: "Cancel",
                            primaryButtonHandler: { [weak self] in
                                self?.onSubmitSearch()
                            },
                            secondaryButtonHandler: nil
                        ))
                    case .unknownError:
                        logger.error("GraphQLError.unknownError:")
                        self.dialog = .alert(viewData: .init(
                            title: "Failed to Search Repository",
                            message: "An unknown error has occurred.",
                            buttonText: "Close",
                            handler: nil
                        ))
                    }
                }
            } receiveValue: { value in
                self.hasNextPage = value.pageInfo.hasNextPage
                self.repositoryCount = value.repositoryCount
                self.data = value.edges.compactMap { $0?.node }
            }
    }
}
