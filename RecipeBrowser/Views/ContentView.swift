//
//  ContentView.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/18/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MealListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.meals) { meal in
                NavigationLink(destination: MealDetailView(mealID: meal.id)) {
                    HStack {
                        AsyncImage(url: URL(string: meal.thumbnail)) { image in
                            image.resizable().aspectRatio(contentMode: .fill).frame(width: 50, height: 50).clipped()
                        } placeholder: {
                            ProgressView()
                        }
                        Text(meal.name)
                    }
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
        }
    }
}
