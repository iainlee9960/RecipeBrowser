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
    @StateObject private var viewModel = MealDetailViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            if let meal = viewModel.mealDetail {
                Text(meal.name).font(.largeTitle).padding()
                Text("Instructions").font(.headline).padding([.leading, .trailing, .top])
                Text(meal.instructions).padding([.leading, .trailing, .bottom])
                Text("Ingredients").font(.headline).padding([.leading, .trailing, .top])
                ForEach(meal.ingredients, id: \.self) { ingredient in
                    Text(ingredient).padding([.leading, .trailing, .bottom])
                }
            } else if viewModel.isLoading {
                ProgressView("Loading...").padding()
            } else if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)").padding()
            }
        }
        .navigationTitle("Meal Details")
        .onAppear {
            viewModel.fetchMealDetail(mealID: mealID)
        }
    }
}
