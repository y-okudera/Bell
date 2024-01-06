//
//  GitHubUserSearchViewModel.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/02.
//

import Combine
import Foundation
import GraphQL_Dependency
import GraphQL_Domain
import GraphQL_Interface

final class GitHubUserSearchViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private lazy var gitHubUserController: GitHubUserController = DependencyContainer.shared.resolve(key: InjectionKey.gitHubUserController.capitalized)

    @Published private(set) var searchText: String = ""
    @Published private(set) var didSearchText: String = ""
    @Published private(set) var isInitialLoading: Bool = false
    @Published private(set) var isAdditionalLoading: Bool = false
    @Published private(set) var dismissSearch: Bool = false
    @Published private(set) var data: [GitHubUser] = []
    @Published private(set) var pageInfo: PageInfo?
    @Published private(set) var userCount: Int = 0
    @Published private(set) var dialog: Dialog?

    var navigationTitle: String {
        self.didSearchText.isEmpty ? "Users" : "\(self.didSearchText): \(String.localizedStringWithFormat("%d", self.userCount))"
    }

    func searchBarTextDidChange(to text: String) {
        self.searchText = text
    }

    func dialogDidChange(to dialog: Dialog?) {
        self.dialog = dialog
    }

    func onSubmitSearch() {
        self.isInitialLoading = true
        self.dismissSearch = false
        let input = GitHubSearchFilterInput(after: nil, first: 10, query: self.searchText)
        self.gitHubUserController.listGitHubUser(input: input)
            .sink { completion in
                defer {
                    self.isInitialLoading = false
                }
                switch completion {
                case .finished:
                    logger.trace(".finished")
                    self.didSearchText = self.searchText
                    self.dismissSearch = true
                case let .failure(error):
                    self.handleSearchError(error)
                }
            } receiveValue: { value in
                self.handleSearchResults(value, isAdditionalRequest: false)
            }
            .store(in: &self.cancellables)
    }

    func onAppearItem(itemData: GitHubUser) {
        if self.data.last == itemData && self.pageInfo?.hasNextPage == true {
            self.performAdditionalRequest()
        }
    }

    func performAdditionalRequest() {
        if self.isAdditionalLoading {
            return
        }
        self.isAdditionalLoading = true
        let input = GitHubSearchFilterInput(after: self.pageInfo?.endCursor, first: 20, query: self.didSearchText)
        self.gitHubUserController.listGitHubUser(input: input)
            .sink { completion in
                defer {
                    self.isAdditionalLoading = false
                }
                switch completion {
                case .finished:
                    logger.trace(".finished")
                case let .failure(error):
                    self.handleSearchError(error)
                }
            } receiveValue: { value in
                self.handleSearchResults(value, isAdditionalRequest: true)
            }
            .store(in: &self.cancellables)
    }

    private func handleSearchResults(_ response: GitHubUserConnection, isAdditionalRequest: Bool) {
        self.pageInfo = response.pageInfo
        self.userCount = response.totalCount
        if isAdditionalRequest {
            self.data.append(contentsOf: response.edges.compactMap { $0 }.map { $0.node })
        } else {
            self.data = response.edges.compactMap { $0 }.map { $0.node }
        }
    }

    private func handleSearchError(_ error: GraphQLError) {
        switch error {
        case let .gqlError(errors: errors):
            logger.error("\(errors)")
            self.dialog = .alert(viewData: .init(
                title: "Failed to Search User",
                message: "A GraphQL error has occurred.\n\n" + errors.map { $0.localizedDescription }.joined(separator: "\n\n"),
                buttonText: "Close",
                handler: nil
            ))
        case let .networkError(error: error):
            logger.error("\(error)")
            self.dialog = .confirm(viewData: .init(
                title: "Failed to Search User",
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
                title: "Failed to Search User",
                message: "An unknown error has occurred.",
                buttonText: "Close",
                handler: nil
            ))
        }
    }
}
