//
//  AsyncImageView.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/18/24.
//

import Foundation
import SwiftUI

struct AsyncImageView<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    let placeholder: Placeholder

    init(url: URL, placeholder: Placeholder) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder
    }

    var body: some View {
        image
            .onAppear {
                loader.load()
            }
    }

    private var image: some View {
        Group {
            if let uiImage = loader.image {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                placeholder
            }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL

    init(url: URL) {
        self.url = url
    }

    func load() {
        guard image == nil else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = uiImage
                }
            }
        }
        task.resume()
    }
}
