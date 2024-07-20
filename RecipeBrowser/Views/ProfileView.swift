//
//  ProfileView.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/20/24.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var selectedMeal: Meal?
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Saved Recipes")
                .font(.largeTitle)
                .padding(.vertical, 10)
            
            if viewModel.savedRecipes.isEmpty {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        Text("No saved recipes.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.savedRecipes) { meal in
                            CardView(viewModel: viewModel, meal: meal)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedMeal = meal
                                }
                        }
                    }
                    .padding()
                }
                .sheet(item: $selectedMeal) { meal in
                    MealDetailView(mealID: meal.id, mealThumbnail: meal.thumbnail)
                }
            }
        }
    }
}
