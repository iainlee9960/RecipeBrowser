//
//  Meal.swift
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
