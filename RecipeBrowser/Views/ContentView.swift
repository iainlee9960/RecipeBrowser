//
//  ContentView.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/18/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MealListViewModel()
    @State private var selectedMeal: Meal?
    
    var body: some View {
        NavigationView {
            List(viewModel.meals) { meal in
                HStack {
                    if let url = URL(string: meal.thumbnail) {
                        AsyncImageView(url: url, placeholder: Image(systemName: "photo"))
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipped()
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipped()
                    }
                    Text(meal.name)
                }
                .onTapGesture {
                    selectedMeal = meal
                }
            }
            .navigationTitle("Desserts")
            .onAppear {
                viewModel.fetchMeals()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.error != nil },
                set: { _ in viewModel.error = nil }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.error?.localizedDescription ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .sheet(item: $selectedMeal) { meal in
                MealDetailView(mealID: meal.id, mealThumbnail: meal.thumbnail)
            }
        }
    }
}
