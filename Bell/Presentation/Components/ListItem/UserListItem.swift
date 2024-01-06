//
//  UserListItem.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/03.
//

import GraphQL_Domain
import SwiftUI

struct UserListItem: View {
    @Environment(\.openURL) var openURL
    let user: GitHubUser
    var body: some View {
        Button(action: {
            if let url = self.user.url {
                self.openURL(url)
            }
        }, label: {
            HStack {
                if let avatarUrl = self.user.avatarUrl {
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
                    Text(self.user.login)
                        .bold()
                        .foregroundStyle(.primary)
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
    let user = GitHubUser(
        id: "MDQ6VXNlcjEzNzkyOTk2",
        avatarUrl: .init(string: "https://avatars.githubusercontent.com/u/13792996?u=ccf6efef79a16b746d26bc199ba78920d4629fda&v=4")!,
        login: "memoiry",
        resourcePath: .init(string: "/memoiry")!,
        url: .init(string: "https://github.com/memoiry")!
    )
    return UserListItem(user: user)
}
