//
//  RandomRootData.swift
//  MealHack
//
//  Created by Chun Long Fong on 28/4/21.
//

import UIKit

class RandomRootData: NSObject, Decodable {
    var recipes: [RecipeData]?
    
    private enum CodingKeys: String, CodingKey {
        case recipes = "recipes"
    }
}
