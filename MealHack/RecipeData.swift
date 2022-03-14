//
//  RecipeData.swift
//  MealHack
//
//  Created by Chun Long Fong on 25/4/21.
//

import UIKit

class RecipeData: NSObject, Decodable {
    var id: Int?
    var title: String?
    var image: String?
    var imageType: String?
    var readyInMinutes: Int?
    
    private enum RecipeKeys: String, CodingKey {
        case id
        case title
        case image
        case imageType
        case readyInMinutes
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RecipeKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try? container.decode(String.self, forKey: .title)
        image = try? container.decode(String.self, forKey:
        .image)
        imageType = try? container.decode(String.self, forKey:
        .imageType)
        readyInMinutes = try container.decode(Int.self, forKey: .readyInMinutes)
        
    }
}
