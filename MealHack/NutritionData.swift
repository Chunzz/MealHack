//
//  NutritionData.swift
//  MealHack
//
//  Created by Chun Long Fong on 2/5/21.
//

import UIKit

class NutritionData: NSObject, Decodable {
    var name: String?
    var title: String?
    var amount: Float?
    var unit: String?

    private enum NutrientKey: String, CodingKey {
        case name
        case title
        case amount
        case unit
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NutrientKey.self)
        
        name = try container.decode(String.self, forKey: .name)
        title = try container.decode(String.self, forKey: .title)
        amount = try container.decode(Float.self, forKey: .amount)
        unit = try container.decode(String.self, forKey: .unit)
    }
}

