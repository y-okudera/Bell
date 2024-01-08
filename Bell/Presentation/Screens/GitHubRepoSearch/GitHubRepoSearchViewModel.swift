//
//  GitHubRepoSearchViewModel.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/02.
//

import Combine
import GraphQL_Dependency
import GraphQL_Domain
import GraphQL_Interface

final class GitHubRepoSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var dialog: Dialog?
    @Published private(set) var loadingState: GitHubRepoLoadingState = .idle

    private lazy var gitHubRepoController: GitHubRepoController = DependencyContainer.shared.resolve(key: InjectionKey.gitHubRepoController.capitalized)
    private var cancellables: Set<AnyCancellable> = []
    private var isInitialLoading: Bool = false
    private var isAdditionalLoading: Bool = false
    private var searchedText: String = ""
    private var data: [GitHubRepo] = []
    private var pageInfo: PageInfo?
    private var repositoryCount: Int = 0

    var navigationTitle: String {
        self.searchedText.isEmpty ? "Repositories" : "\(self.searchedText): \(String.localizedStringWithFormat("%d", self.repositoryCount))"
    }

    func onChooseRecommendedKeyword(_ keyword: String) {
        self.searchText = keyword
        self.onSubmitSearch()
    }

    func onSubmitSearch() {
        self.isInitialLoading = true
        self.updateState()

        self.gitHubRepoController.listGitHubRepo(input: .init(after: nil, first: 10, query: self.searchText))
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self.handleSearchError(error, isAdditionalRequest: false)
                }
            } receiveValue: { value in
                self.handleSearchResults(value, isAdditionalRequest: false)
            }
            .store(in: &self.cancellables)
    }

    func onAppearItem(itemData: GitHubRepo) {
        if self.data.last == itemData && self.pageInfo?.hasNextPage == true {
            self.performAdditionalRequest()
        }
    }

    func performAdditionalRequest() {
        if self.loadingState == .initialLoading || self.isAdditionalLoading {
            return
        }
        self.isAdditionalLoading = true
        self.updateState()
        self.gitHubRepoController.listGitHubRepo(input: .init(after: self.pageInfo?.endCursor, first: 20, query: self.searchedText))
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self.handleSearchError(error, isAdditionalRequest: true)
                }
            } receiveValue: { value in
                self.handleSearchResults(value, isAdditionalRequest: true)
            }
            .store(in: &self.cancellables)
    }

    func updateState() {
        if self.isInitialLoading {
            self.loadingState = .initialLoading
        } else if self.isAdditionalLoading {
            self.loadingState = .loaded(data: self.data, isAdditionalLoading: self.isAdditionalLoading)
        } else if self.data.isEmpty {
            self.loadingState = self.searchedText.isEmpty ? .idle : .emptyState
        } else {
            self.loadingState = .loaded(data: self.data, isAdditionalLoading: self.isAdditionalLoading)
        }
    }

    private func handleSearchResults(_ response: GitHubRepoConnection, isAdditionalRequest: Bool) {
        self.pageInfo = response.pageInfo
        self.repositoryCount = response.totalCount
        if isAdditionalRequest {
            self.isAdditionalLoading = false
            self.data.append(contentsOf: response.edges.compactMap { $0 }.map { $0.node })
        } else {
            self.isInitialLoading = false
            self.data = response.edges.compactMap { $0 }.map { $0.node }
            self.searchedText = self.searchText
        }
        self.updateState()
    }

    private func handleSearchError(_ error: GraphQLError, isAdditionalRequest: Bool) {
        if isAdditionalRequest {
            self.isAdditionalLoading = false
        } else {
            self.isInitialLoading = false
        }
        self.updateState()
        switch error {
        case let .gqlError(errors: errors):
            logger.error("\(errors)")
            self.dialog = .alert(viewData: .init(
                title: "Failed to Search Repository",
                message: "A GraphQL error has occurred.\n\n" + errors.map { $0.localizedDescription }.joined(separator: "\n\n"),
                buttonText: "Close",
                handler: nil
            ))
        case let .networkError(error: error):
            logger.error("\(error)")
            self.dialog = .confirm(viewData: .init(
                title: "Failed to Search Repository",
                message: "Please check your network connection and try again.",
                primaryButtonText: "Retry",
                secondaryButtonText: "Cancel",
                primaryButtonHandler: { [weak self] in
                    if isAdditionalRequest {
                        self?.performAdditionalRequest()
                    } else {
                        self?.onSubmitSearch()
                    }
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
