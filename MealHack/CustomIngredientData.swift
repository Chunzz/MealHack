//
//  CustomIngredientData.swift
//  MealHack
//
//  Created by Chun Long Fong on 5/6/21.
//

import UIKit

class CustomIngredientData: NSObject, Decodable {
    var name: String?
    var id: Int?
    
    private enum RecipeKeys: String, CodingKey {
        case name
        case id
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RecipeKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)
    }
}
