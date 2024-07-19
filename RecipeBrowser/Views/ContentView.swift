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

    let columns = [
        GridItem(.flexible())
    ]

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

                ScrollView {
                    if selectedCategory != nil {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search meals", text: $searchQuery)
                                .foregroundColor(.primary)
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(15)
                                .onChange(of: searchQuery) { newValue in
                                    viewModel.filterMeals(query: newValue)
                                }
                            if !searchQuery.isEmpty {
                                Button(action: {
                                    searchQuery = ""
                                    viewModel.filterMeals(query: "")
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.filteredMeals) { meal in
                            Button(action: {
                                selectedMeal = meal
                            }) {
                                CardView(meal: meal)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
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
