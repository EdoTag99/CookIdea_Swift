//
//  Ingredients.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 22/07/24.
//

import Foundation

struct Ingredient: Codable, Identifiable{
    let id: Int
    let name: String
    let quantity: Int
}
