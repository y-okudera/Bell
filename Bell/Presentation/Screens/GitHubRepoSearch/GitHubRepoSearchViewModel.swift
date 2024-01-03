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
    private var cancellables: Set<AnyCancellable> = []
    private lazy var gitHubRepoController: GitHubRepoController = DependencyContainer.shared.resolve(key: InjectionKey.gitHubRepoController.capitalized)

    @Published private(set) var searchText: String = ""
    @Published private(set) var didSearchText: String = ""
    @Published private(set) var dismissSearch: Bool = false
    @Published private(set) var data: [GitHubRepoListResponse.Edge.Node] = []
    @Published private(set) var pageInfo: PageInfo?
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
        let input = GitHubRepoFilterInput(after: nil, first: 10, query: self.searchText)
        self.gitHubRepoController.listGitHubRepo(input: input)
            .sink { completion in
                switch completion {
                case .finished:
                    logger.trace(".finished")
                    self.didSearchText = self.searchText
                    self.dismissSearch = true
                case .failure(let error):
                    self.handleSearchError(error)
                }
            } receiveValue: { value in
                self.handleSearchResults(value, isAdditionalRequest: false)
            }
            .store(in: &self.cancellables)
    }

    func onAppearItem(itemData: GitHubRepoListResponse.Edge.Node) {
        if self.data.last == itemData && self.pageInfo?.hasNextPage == true {
            self.performAdditionalRequest()
        }
    }

    func performAdditionalRequest() {
        let input = GitHubRepoFilterInput(after: self.pageInfo?.endCursor, first: 20, query: self.didSearchText)
        self.gitHubRepoController.listGitHubRepo(input: input)
            .sink { completion in
                switch completion {
                case .finished:
                    logger.trace(".finished")
                    break
                case .failure(let error):
                    self.handleSearchError(error)
                }
            } receiveValue: { value in
                self.handleSearchResults(value, isAdditionalRequest: true)
            }
            .store(in: &self.cancellables)
    }

    private func handleSearchResults(_ response: GitHubRepoListResponse, isAdditionalRequest: Bool) {
        self.pageInfo = response.pageInfo
        self.repositoryCount = response.repositoryCount
        if isAdditionalRequest {
            self.data.append(contentsOf: response.edges.compactMap { $0?.node })
        } else {
            self.data = response.edges.compactMap { $0?.node }
        }
    }

    private func handleSearchError(_ error: GraphQLError) {
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
}
