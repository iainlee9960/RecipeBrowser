//
//  Models.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/18/24.
//

import Foundation
import SwiftUI

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

extension Color {
    //static let mainColor = Color(UIColor(red: 118/255, green: 221/255, blue: 253/255, alpha: 1)) // OG Light Blue
    // i think this is the most appetizing color by far
    static let mainColor = Color(UIColor(red: 250/255, green: 100/255, blue: 100/255, alpha: 1)) // Pastel Red
        
    // similar to Light Blue, its a food app i don't really like it
    //static let mainColor = Color(UIColor(red: 118/255, green: 253/255, blue: 221/255, alpha: 1))
    //static let mainColor = Color(UIColor(red: 118/255, green: 190/255, blue: 253/255, alpha: 1))
    
    // similar to Red, also good, but not good enough
    //static let mainColor = Color(UIColor(red: 253/255, green: 150/255, blue: 118/255, alpha: 1))
    //static let mainColor = Color(UIColor(red: 253/255, green: 118/255, blue: 150/255, alpha: 1))
    
    // Complementary colors
    //static let mainColor = Color(UIColor(red: 253/255, green: 118/255, blue: 172/255, alpha: 1)) // Pink
    //static let mainColor = Color(UIColor(red: 100/255, green: 250/255, blue: 250/255, alpha: 1)) // Light Cyan
    
    // Triadic colors
    //static let mainColor = Color(UIColor(red: 253/255, green: 253/255, blue: 118/255, alpha: 1))
    //static let mainColor = Color(UIColor(red: 221/255, green: 118/255, blue: 253/255, alpha: 1))
    
    // some extra colors, could use for some accenting
    //static let mainColor = Color(UIColor(red: 100/255, green: 250/255, blue: 100/255, alpha: 1))
    //static let mainColor = Color(UIColor(red: 100/255, green: 100/255, blue: 250/255, alpha: 1))
}
