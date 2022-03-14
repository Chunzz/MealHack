//
//  AddIngredient.swift
//  MealHack
//
//  Created by Chun Long Fong on 5/6/21.
//

import UIKit

class AddIngredient: NSObject {
    var name: String?
    var quantity: Float?
    var unit: String?
    
    init(name: String?, quantity: Float?, unit: String?){
        self.name = name;
        self.quantity = quantity
        self.unit = unit
    }
}
