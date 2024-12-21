//
//  APIManager.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 17/07/24.
//

import Foundation

struct APIManager {
    //let baseUrl: URL = URL(string: "http://192.168.1.122:8000")!
    let baseUrl: URL = URL(string: "http://172.20.10.2:8000")!

    var servings: URL { return baseUrl.appendingPathComponent("/api/servings")}
    var carouselImages: URL { return baseUrl.appendingPathComponent("/api/carouselRecipes")}
    var servingRecipes: URL { return baseUrl.appendingPathComponent("/api/filteredByServing")}
    var recipeSearch: URL { return baseUrl.appendingPathComponent("/api/searchRecipe")}
    var recipeByID: URL { return baseUrl.appendingPathComponent("/api/recipeByID")}
    var login: URL { return baseUrl.appendingPathComponent("/api/login")}
    var register: URL { return baseUrl.appendingPathComponent("/api/register")}
    var isRecipeFavourite: URL { return baseUrl.appendingPathComponent("/api/isRecipeFavourite")}
    var toggleFavourite: URL { return baseUrl.appendingPathComponent("/api/toggleFavourite")}
    var favouriteRecipes: URL { return baseUrl.appendingPathComponent("/api/favouriteRecipes")}
    var weeklyMenu: URL { return baseUrl.appendingPathComponent("/api/weeklyMenu")}
    var addWeeklyMenu: URL { return baseUrl.appendingPathComponent("/api/addWeeklyMenu")}
    var meals: URL { return baseUrl.appendingPathComponent("/api/meals")}
}

enum APIErrors: Error {
    case serverError
    case loginError
    case decodingError
    case invalidUserID
}
