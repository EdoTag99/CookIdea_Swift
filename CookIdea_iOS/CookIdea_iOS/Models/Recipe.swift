//
//  Recipe.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 18/07/24.
//

import Foundation

struct Recipe: Identifiable, Codable {
    let id: Int
    let name: String
    let difficulty: Int?
    let time: Int?
    let servingName: String?
    let provenance: String?
    let description: String?
    let ingredients: [Ingredient]?
    let imageUrl: String
    var isFavourite: Bool?
    
    init(id: Int, name: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.difficulty = nil
        self.time = nil
        self.servingName = nil
        self.provenance = nil
        self.description = nil
        self.ingredients = nil
        self.imageUrl = imageUrl
        self.isFavourite = nil
    }
    
    init(id: Int, name:String, difficulty: Int, time: Int, servingName: String, provenance: String, description: String, ingredients: [Ingredient], imageUrl: String, isFavourite: Bool?) {
        self.id = id
        self.name = name
        self.difficulty = difficulty
        self.time = time
        self.servingName = servingName
        self.provenance = provenance
        self.description = description
        self.ingredients = ingredients
        self.imageUrl = imageUrl
        self.isFavourite = isFavourite
    }
}

struct SearchRecipe: Identifiable, Codable{
    let id: Int
}
