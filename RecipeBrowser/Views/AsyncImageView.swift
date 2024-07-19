//
//  AsyncImageView.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/18/24.
//

import Foundation
import SwiftUI

@MainActor
class AsyncImageLoader: ObservableObject {
    @Published var image: UIImage?

    func load(url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                self.image = uiImage
            } else {
                print("Error: Image data is invalid")
            }
        } catch {
            print("Error loading image: \(error.localizedDescription)")
        }
    }
}


struct AsyncImageView: View {
    @StateObject private var loader = AsyncImageLoader()
    let url: URL
    let placeholder: Image

    var body: some View {
        image
            .task {
                await loader.load(url: url)
            }
    }

    private var image: some View {
        Group {
            if let uiImage = loader.image {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                placeholder
                    .resizable()
            }
        }
    }
}
