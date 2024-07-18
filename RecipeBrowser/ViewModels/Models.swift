//
//  Models.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/18/24.
//

import Foundation

struct Meal: Codable, Identifiable {
    let id: String
    let name: String
    let thumbnail: String

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnail = "strMealThumb"
    }
}

struct MealDetail: Codable {
    let id: String
    let name: String
    let instructions: String
    let ingredients: [String]

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
        case ingredients = "ingredients"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.instructions = try container.decode(String.self, forKey: .instructions)

        var ingredients = [String]()
        for i in 1...20 {
            let ingredientKey = "strIngredient\(i)"
            let measureKey = "strMeasure\(i)"
            if let ingredient = try container.decodeIfPresent(String.self, forKey: CodingKeys(rawValue: ingredientKey)!),
               let measure = try container.decodeIfPresent(String.self, forKey: CodingKeys(rawValue: measureKey)!),
               !ingredient.isEmpty, !measure.isEmpty {
                ingredients.append("\(ingredient) - \(measure)")
            }
        }
        self.ingredients = ingredients
    }
}
