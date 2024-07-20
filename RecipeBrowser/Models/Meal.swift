//
//  Meal.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/18/24.
//

import Foundation

struct Meal: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let thumbnail: String

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnail = "strMealThumb"
    }

    static func ==(lhs: Meal, rhs: Meal) -> Bool {
        return lhs.id == rhs.id
    }
}
