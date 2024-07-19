//
//  MealListViewModel.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/18/24.
//

import Foundation

class MealListViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var meals: [Meal] = []
    @Published var filteredMeals: [Meal] = []
    @Published var isLoading = false
    @Published var error: Error?

    func fetchCategories() {
        isLoading = true
        error = nil
        Task {
            do {
                let fetchedCategories = try await NetworkManager.shared.fetchCategories()
                let sortedCategories = fetchedCategories.sorted { $0.name == "Dessert" && $1.name != "Dessert" }
                DispatchQueue.main.async {
                    self.categories = sortedCategories
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }

    func fetchMeals(category: String) {
        isLoading = true
        error = nil
        Task {
            do {
                let fetchedMeals = try await NetworkManager.shared.fetchMeals(for: category)
                DispatchQueue.main.async {
                    self.meals = fetchedMeals
                    self.filteredMeals = fetchedMeals
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }

    func filterMeals(query: String) {
        if query.isEmpty {
            filteredMeals = meals
        } else {
            filteredMeals = meals.filter { $0.name.localizedCaseInsensitiveContains(query) }
        }
    }
}
