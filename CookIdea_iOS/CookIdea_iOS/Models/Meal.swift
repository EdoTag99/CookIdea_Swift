//
//  Meal.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 10/08/24.
//

import Foundation

struct Meal: Codable, Identifiable, Hashable{
    var id: Int
    var name: String
}
