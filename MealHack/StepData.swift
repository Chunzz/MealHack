//
//  StepData.swift
//  MealHack
//
//  Created by Chun Long Fong on 16/5/21.
//

import UIKit

class StepData: NSObject, Decodable{
    var number: Int?
    var step: String

    private enum NutrientKey: String, CodingKey {
        case number = "number"
        case step = "step"
    }
}
