//
//  SearchPageViewModel.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 20/07/24.
//

import Foundation

//@Observable class SearchPageViewModel {
//    var Search: String = ""
//    var Result: [Recipe] = []
//    
//    func FetchRecipeServings(servingName: String) async throws{
//        let (data, response) = try await URLSession.shared.data(from: APIManager().servingRecipes.appending(queryItems: [URLQueryItem(name: "serving", value: servingName)]))
//        guard let httpResponse = response as? HTTPURLResponse,
//              httpResponse.statusCode == 200 else {
//            throw APIErrors.serverError
//        }
//        
//        do {
//            let decodedRecipes = try JSONDecoder().decode([Recipe].self, from: data)
//            DispatchQueue.main.async {
//                self.Result = decodedRecipes
//            }
//        } catch {
//            throw APIErrors.decodingError
//        }
//    }
//    
//    func FetchRecipeSearch() async throws{
//        let (data, response) = try await URLSession.shared.data(from: APIManager().recipeSearch.appending(queryItems: [URLQueryItem(name: "recipeName", value: Search)]))
//        guard let httpResponse = response as? HTTPURLResponse,
//              httpResponse.statusCode == 200 else {
//            throw APIErrors.serverError
//        }
//        
//        do {
//            let decodedRecipes = try JSONDecoder().decode([Recipe].self, from: data)
//            DispatchQueue.main.async {
//                self.Result = decodedRecipes
//            }
//        } catch {
//            throw APIErrors.decodingError
//        }
//    }
//}
