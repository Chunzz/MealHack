//
//  SearchRootData.swift
//  MealHack
//
//  Created by Chun Long Fong on 15/5/21.
//

import UIKit

class SearchRootData: NSObject, Decodable {
    var recipes: [RecipeData]?

    private enum CodingKeys: String, CodingKey {
        case recipes = "results"
    }
}
