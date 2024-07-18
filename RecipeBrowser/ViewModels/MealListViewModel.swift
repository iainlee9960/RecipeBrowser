//
//  MealListViewModel.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/18/24.
//

import Foundation

class MealListViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var isLoading = false
    @Published var error: Error?

    func fetchMeals() {
        isLoading = true
        error = nil
        Task {
            do {
                let meals = try await NetworkManager.shared.fetchDessertMeals()
                DispatchQueue.main.async {
                    self.meals = meals
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
}
