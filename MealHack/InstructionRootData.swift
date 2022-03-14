//
//  InstructionRootData.swift
//  MealHack
//
//  Created by Chun Long Fong on 16/5/21.
//

import UIKit

class InstructionRootData: NSObject, Decodable {
    var instructions: [InstructionData]?

    private enum CodingKeys: String, CodingKey {
        case instructions
    }
}
