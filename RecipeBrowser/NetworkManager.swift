//
//  NetworkManager.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/18/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://themealdb.com/api/json/v1/1/"

    private init() {}

    func fetchDessertMeals() async throws -> [Meal] {
        guard let url = URL(string: "\(baseURL)filter.php?c=Dessert") else { fatalError("Invalid URL") }
        let (data, _) = try await URLSession.shared.data(from: url)
        let meals = try JSONDecoder().decode(MealResponse.self, from: data)
        return meals.meals.sorted(by: { $0.name < $0.name })
    }

    func fetchMealDetails(mealID: String) async throws -> MealDetail {
        guard let url = URL(string: "\(baseURL)lookup.php?i=\(mealID)") else { fatalError("Invalid URL") }
        let (data, _) = try await URLSession.shared.data(from: url)
        let mealDetails = try JSONDecoder().decode(MealDetailResponse.self, from: data)
        return mealDetails.meals.first!
    }
}

struct MealResponse: Codable {
    let meals: [Meal]
}

struct MealDetailResponse: Codable {
    let meals: [MealDetail]
}
