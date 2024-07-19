//
//  NetworkManager.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/18/24.
//

import Foundation

struct Category: Codable, Identifiable, Hashable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case name = "strCategory"
    }
}

struct CategoryResponse: Codable {
    let categories: [Category]
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://themealdb.com/api/json/v1/1/"

    private init() {}

    func fetchCategories() async throws -> [Category] {
        guard let url = URL(string: "\(baseURL)categories.php") else { fatalError("Invalid URL") }
        let (data, _) = try await URLSession.shared.data(from: url)
        let categories = try JSONDecoder().decode(CategoryResponse.self, from: data)
        return categories.categories
    }

    func fetchMeals(for category: String) async throws -> [Meal] {
        guard let url = URL(string: "\(baseURL)filter.php?c=\(category)") else { fatalError("Invalid URL") }
        let (data, _) = try await URLSession.shared.data(from: url)
        let meals = try JSONDecoder().decode(MealResponse.self, from: data)
        return meals.meals.filter { !$0.name.isEmpty }.sorted(by: { $0.name < $1.name })
    }

    func fetchMealDetails(mealID: String) async throws -> MealDetail {
        guard let url = URL(string: "\(baseURL)lookup.php?i=\(mealID)") else { fatalError("Invalid URL") }
        let (data, _) = try await URLSession.shared.data(from: url)
        let mealDetails = try JSONDecoder().decode(MealDetailResponse.self, from: data)
        guard let mealDetail = mealDetails.meals.first else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No meal detail found"])
        }
        return mealDetail
    }
}

struct MealResponse: Codable {
    let meals: [Meal]
}

struct MealDetailResponse: Codable {
    let meals: [MealDetail]
}
