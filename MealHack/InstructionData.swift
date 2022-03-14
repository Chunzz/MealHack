//
//  InstructionData.swift
//  MealHack
//
//  Created by Chun Long Fong on 16/5/21.
//

import UIKit

class InstructionData: NSObject, Decodable {
    var name: String?
    var steps: [StepData]?

    private enum NutrientKey: String, CodingKey {
        case name = "name"
        case steps = "steps"
    }
}
