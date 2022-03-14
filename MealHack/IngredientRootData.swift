//
//  IngredientRootData.swift
//  MealHack
//
//  Created by Chun Long Fong on 29/4/21.
//

import UIKit

class IngredientRootData: NSObject, Decodable {
    var ingredients: [IngredientData]?
    
    private enum CodingKeys: String, CodingKey {
        case ingredients = "ingredients"
    }
}
