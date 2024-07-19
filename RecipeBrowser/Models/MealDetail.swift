//
//  MealDetail.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/18/24.
//

import Foundation

struct MealDetail: Codable {
    let id: String
    let name: String
    let instructions: String
    let ingredients: [String]

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
    }

    struct IngredientKeys: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }

        init?(intValue: Int) {
            return nil
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.instructions = try container.decode(String.self, forKey: .instructions)

        var ingredients = [String]()
        let ingredientContainer = try decoder.container(keyedBy: IngredientKeys.self)
        for i in 1...20 {
            let ingredientKey = IngredientKeys(stringValue: "strIngredient\(i)")!
            let measureKey = IngredientKeys(stringValue: "strMeasure\(i)")!

            if let ingredient = try ingredientContainer.decodeIfPresent(String.self, forKey: ingredientKey),
               let measure = try ingredientContainer.decodeIfPresent(String.self, forKey: measureKey),
               !ingredient.isEmpty, !measure.isEmpty {
                ingredients.append("\(ingredient) - \(measure)")
            }
        }
        self.ingredients = ingredients
    }
}
