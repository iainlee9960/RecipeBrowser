//
//  MainViewModel.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/20/24.
//

import Foundation
import SwiftUI

enum ViewType {
    case home
    case profile
}
import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var currentView: ViewType = .home
    @Published var savedRecipes: [Meal] = [] {
        didSet {
            saveRecipesToUserDefaults()
        }
    }
    @Published var categories: [Category] = []
    @Published var meals: [Meal] = []
    @Published var filteredMeals: [Meal] = []
    @Published var isLoading = false
    @Published var error: Error?

    private let savedRecipesKey = "savedRecipes"

    init() {
        loadSavedRecipesFromUserDefaults()
    }

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

    func saveRecipe(_ meal: Meal) {
        if !savedRecipes.contains(meal) {
            savedRecipes.append(meal)
        }
    }

    func removeRecipe(_ meal: Meal) {
        if let index = savedRecipes.firstIndex(of: meal) {
            savedRecipes.remove(at: index)
        }
    }

    private func saveRecipesToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(savedRecipes) {
            UserDefaults.standard.set(encoded, forKey: savedRecipesKey)
        }
    }

    private func loadSavedRecipesFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: savedRecipesKey),
           let decoded = try? JSONDecoder().decode([Meal].self, from: savedData) {
            savedRecipes = decoded
        }
    }
}
