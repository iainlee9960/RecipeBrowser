//
//  MealDetailView.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/18/24.
//

import Foundation
import SwiftUI

struct MealDetailView: View {
    let mealID: String
    let mealThumbnail: String
    @StateObject private var viewModel = MealDetailViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let meal = viewModel.mealDetail {
                    Text(meal.name)
                        .font(.largeTitle)
                        .padding()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    AsyncImage(url: URL(string: mealThumbnail)) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(maxWidth: .infinity)
                    } placeholder: {
                        ProgressView()
                    }
                    .padding()

                    Text("Instructions")
                        .font(.headline)
                        .padding([.leading, .trailing, .top])
                    
                    Text(meal.instructions)
                        .padding([.leading, .trailing, .bottom])
                        .multilineTextAlignment(.leading)
                    
                    Text("Ingredients")
                        .font(.headline)
                        .padding([.leading, .trailing, .top])
                    
                    ForEach(meal.ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                            .padding([.leading, .trailing, .bottom])
                            .multilineTextAlignment(.leading)
                    }
                } else if viewModel.isLoading {
                    ProgressView("Loading...").padding()
                } else if let error = viewModel.error {
                    Text("Error: \(error.localizedDescription)").padding()
                }
            }
        }
        .onAppear {
            viewModel.fetchMealDetail(mealID: mealID)
        }
    }
}
