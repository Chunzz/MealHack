//
//  CustomIngredientRootData.swift
//  MealHack
//
//  Created by Chun Long Fong on 5/6/21.
//

import UIKit

class CustomIngredientRootData: NSObject, Decodable {
    var ingredients: [CustomIngredientData]?
    
    private enum CodingKeys: String, CodingKey {
        case ingredients = "results"
    }
}
