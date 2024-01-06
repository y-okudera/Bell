//
//  RepositoryListItem.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/03.
//

import GraphQL_Domain
import SwiftUI

struct RepositoryListItem: View {
    @Environment(\.openURL) var openURL
    let repository: GitHubRepo
    var body: some View {
        Button(action: {
            if let url = self.repository.url {
                self.openURL(url)
            }
        }, label: {
            HStack {
                if let avatarUrl = self.repository.owner.avatarUrl {
                    CachedAsyncImage(url: avatarUrl) { phase in
                        switch phase {
                        case let .success(image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case let .failure(error):
                            let _ = logger.error("\(error.localizedDescription)")
                            Color.gray
                        case .empty:
                            ProgressView()
                        @unknown default:
                            fatalError("AsyncImagePhase @unknown default")
                        }
                    }
                    .frame(width: 50, height: 50)
                }
                VStack {
                    Text(self.repository.nameWithOwner)
                        .bold()
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .topLeading)

                    Text(self.repository.description ?? "-")
                        .foregroundStyle(.secondary)
                        .lineLimit(2, reservesSpace: true)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        })
        .buttonStyle(DefaultButtonStyle())
    }
}

#Preview {
    let repository = GitHubRepo(
        id: "MDEwOlJlcG9zaXRvcnk0NDgzODk0OQ==",
        url: URL(string: "https://github.com/apple/swift"),
        description: "The Swift Programming Language",
        homepageUrl: URL(string: "https://swift.org"),
        nameWithOwner: "apple/swift",
        owner: .init(
            id: "",
            avatarUrl: .init(string: "https://avatars.githubusercontent.com/u/10639145?v=4"),
            login: "",
            resourcePath: nil,
            url: nil
        ),
        stargazerCount: 64875,
        primaryLanguage: .init(
            id: "",
            name: "C++",
            color: nil
        )
    )
    return RepositoryListItem(repository: repository)
}
