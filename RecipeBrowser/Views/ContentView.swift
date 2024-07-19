//
//  ContentView.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/18/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MealListViewModel()
    @State private var selectedCategory: Category?
    @State private var selectedMeal: Meal?
    @State private var searchQuery: String = ""
    
    var body: some View {
        VStack {
            if viewModel.categories.isEmpty {
                ProgressView("Loading categories...")
                    .onAppear {
                        viewModel.fetchCategories()
                    }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.categories) { category in
                            Text(category.name)
                                .font(.system(size: 14))
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(
                                    selectedCategory == category ? Color.mainColor.opacity(0.2) : Color.gray.opacity(0.2)
                                )
                                .foregroundColor(Color.black)
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(selectedCategory == category ? Color.mainColor : Color.clear, lineWidth: 2)
                                )
                                .onTapGesture {
                                    selectedCategory = category
                                    viewModel.fetchMeals(category: category.name)
                                }
                        }
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal)
                }
                
                if selectedCategory != nil {
                    TextField("Search...", text: $searchQuery, onEditingChanged: { _ in
                        viewModel.filterMeals(query: searchQuery)
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                }
                
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
                .onAppear {
                    if let initialCategory = viewModel.categories.first(where: { $0.name == "Dessert" }) ?? viewModel.categories.first {
                        selectedCategory = initialCategory
                        viewModel.fetchMeals(category: initialCategory.name)
                    }
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
}
