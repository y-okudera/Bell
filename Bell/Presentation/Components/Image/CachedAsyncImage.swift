//
//  CachedAsyncImage.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/03.
//

import SwiftUI

struct CachedAsyncImage<Content>: View where Content: View {
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    var body: some View{
        if let cached = ImageCache[self.url] {
            let _ = logger.trace("cached: \(self.url.absoluteString)")
            self.content(.success(cached))
        } else {
            let _ = logger.trace("request: \(self.url.absoluteString)")
            AsyncImage(
                url: self.url,
                scale: self.scale,
                transaction: self.transaction
            ) { phase in
                self.cacheAndRender(phase: phase)
            }
        }
    }

    private func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success (let image) = phase {
            ImageCache[self.url] = image
        }
        return self.content(phase)
    }
}

private class ImageCache {
    static private var cache: [URL: Image] = [:]
    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}

#Preview {
    CachedAsyncImage(url: .init(string: "https://avatars.githubusercontent.com/u/10639145?v=4")!) { phase in
        switch phase {
        case let .success(image):
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        case .failure:
            Color.gray
        case .empty:
            ProgressView()
        @unknown default:
            fatalError("AsyncImagePhase @unknown default")
        }
    }
}
