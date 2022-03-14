//
//  RecipeInfoData.swift
//  MealHack
//
//  Created by Chun Long Fong on 12/5/21.
//

import UIKit

class RecipeInfoData: NSObject, Decodable {
    
    var name: String?
    var amount: Float?
    var unit: String?
    
    private enum RecipeKeys: String, CodingKey {
        case name
        case amount
        case unit
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RecipeKeys.self)
        
        // Get the ingredient info
        name = try container.decode(String.self, forKey: .name)
        amount = try? container.decode(Float.self, forKey: .amount)
        unit = try? container.decode(String.self, forKey: .unit)
    }
}
