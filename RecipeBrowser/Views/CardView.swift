//
//  CardView.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/19/24.
//

import Foundation
import SwiftUI

struct CardView: View {
    @ObservedObject var viewModel: MainViewModel
    let meal: Meal
    
    var body: some View {
        VStack(alignment: .leading) {
            if let url = URL(string: meal.thumbnail) {
                AsyncImageView(url: url, placeholder: Color.gray.opacity(0.3))
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(8, corners: [.topLeft, .topRight])
            } else {
                Color.gray.opacity(0.3)
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .cornerRadius(8, corners: [.topLeft, .topRight])
            }
            HStack {
                Text(meal.name)
                    .font(.headline)
                    .padding([.leading, .bottom, .trailing])
                    .lineLimit(1)
                Spacer()
                Button(action: {
                    if viewModel.savedRecipes.contains(meal) {
                        viewModel.removeRecipe(meal)
                    } else {
                        viewModel.saveRecipe(meal)
                    }
                }) {
                    Image(systemName: viewModel.savedRecipes.contains(meal) ? "bookmark.fill" : "bookmark")
                        .foregroundColor(.black)
                        .padding()
                }
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
