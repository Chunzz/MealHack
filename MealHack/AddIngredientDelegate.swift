//
//  AddIngredientDelegate.swift
//  MealHack
//
//  Created by Chun Long Fong on 5/6/21.
//

import Foundation

protocol AddIngredientDelegate: AnyObject {
    func addIngredient(_ newIngredient: AddIngredient) -> Bool
}
