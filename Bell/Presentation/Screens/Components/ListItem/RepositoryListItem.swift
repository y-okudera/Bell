//
//  RepositoryListItem.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/03.
//

import GraphQL_Domain
import SwiftUI

struct RepositoryListItem: View {

    let repository: GitHubRepoListResponse.Edge.Node
    var body: some View {
        HStack {
            AsyncImage(url: repository.owner.avatarUrl) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            VStack {
                Text(repository.nameWithOwner)
                    .bold()
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .topLeading)

                Text(repository.description ?? "-")
                    .foregroundStyle(.secondary)
                    .lineLimit(2, reservesSpace: true)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
    }
}

#Preview {
    let repository = GitHubRepoListResponse.Edge.Node(
        description: "The Swift Programming Language",
        homepageUrl: URL(string: "https://swift.org"),
        nameWithOwner: "apple/swift",
        owner: .init(avatarUrl: .init(string: "https://avatars.githubusercontent.com/u/10639145?v=4")),
        stargazers: .init(totalCount: 64875),
        primaryLanguage: .init(name: "C++")
    )
    return RepositoryListItem(repository: repository)
}
