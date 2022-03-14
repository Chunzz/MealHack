//
//  RootData.swift
//  MealHack
//
//  Created by Chun Long Fong on 25/4/21.
//

import UIKit

class RootData: NSObject, Decodable {
    var extendedIngredients: [IngredientData]?
    var nutrients: [NutritionData]?
    
    var title: String?
    var readyInMinutes: Int?
    var servings: Int?
    
    private enum CodingKeys: String, CodingKey {
        case extendedIngredients = "extendedIngredients"
        case nutrition
        case title = "title"
        case readyInMinutes = "readyInMinutes"
        case servings = "servings"
    }
    
    private enum NutritionKeys: String, CodingKey {
        case nutrients
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let nutrionContainer = try? container.nestedContainer(keyedBy: NutritionKeys.self, forKey: .nutrition)

        nutrients = try nutrionContainer?.decode([NutritionData].self, forKey: .nutrients)
        extendedIngredients = try container.decode([IngredientData].self, forKey: .extendedIngredients)
        title = try container.decode(String.self, forKey: .title)
        readyInMinutes = try container.decode(Int.self, forKey: .readyInMinutes)
        servings = try container.decode(Int.self, forKey: .servings)
    }
}
