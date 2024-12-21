//
//  RecipeDetailViewModel.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 22/07/24.
//

import Foundation

//@Observable class RecipeDetailViewModel {
//    var recipe: Recipe?
//    func FetchRecipeDetails(recipeID: Int) async throws{
//        let (data, response) = try await URLSession.shared.data(from: APIManager().recipeByID.appending(queryItems: [URLQueryItem(name: "recipeID", value: "\(recipeID)")]))
//        guard let httpResponse = response as? HTTPURLResponse,
//              httpResponse.statusCode == 200 else {
//            throw APIErrors.serverError
//        }
//        
//        do {
//            let decodedRecipe = try JSONDecoder().decode(Recipe.self, from: data)
//            DispatchQueue.main.async {
//                self.recipe = decodedRecipe
//            }
//        } catch {
//            throw APIErrors.decodingError
//        }
//    }
//    
//    func FetchFavouriteRecipe(recipeId: Int, userId: Int) async throws{
//        let (data, response) = try await URLSession.shared.data(from: APIManager().isRecipeFavourite.appending(queryItems: [URLQueryItem(name: "recipeID", value: "\(recipeId)"), URLQueryItem(name: "userID", value: "\(userId)")]))
//        guard let httpResponse = response as? HTTPURLResponse,
//              httpResponse.statusCode == 200 else {
//            throw APIErrors.serverError
//        }
//        
//        do {
//            let isFavourite = try JSONDecoder().decode(Bool.self, from: data)
//            DispatchQueue.main.async {
//                self.recipe?.isFavourite = isFavourite
//            }
//        } catch {
//            throw APIErrors.decodingError
//        }
//    }
//    
//    
//    let exampleRecipe: Recipe? = Recipe(
//        id: 1,
//        name: "Pasta alla Carbonara",
//        difficulty: 2,
//        time: 20,
//        servingName: "Primo",
//        provenance: "Lazio",
//        description: "Mettiamo l’acqua per la pasta sul fuoco e nel frattempo preparate il condimento. Saltiamo in padella il guanciale insieme a un filo d’olio per un paio di minuti, quindi spegniamo il fuoco e mettiamo da parte.\nIn una terrina capiente sgusciamo l’uovo intero e aggiungiamo anche il tuorlo, i formaggi grattugiati e abbondante pepe. Lavoriamo tutti gli ingredienti con una frusta fino a ottenere un composto cremoso e ben amalgamato.\nCuociamo gli spaghetti in acqua salata e scoiamoli al dente direttamente nella ciotola delle uova. Aggiungiamo i cubetti di guanciale e mantechiamo velocemente la pasta.\n",
//        ingredients: [
//            Ingredient(id: 55, name: "Spaghetti", quantity: 200),
//            Ingredient(id: 54, name: "Guanciale", quantity: 100),
//            Ingredient(id: 47, name: "Pepe", quantity: 5),
//            Ingredient(id: 53, name: "Uova", quantity: 2),
//            Ingredient(id: 51, name: "Pecorino", quantity: 25),
//            Ingredient(id: 49, name: "Olio", quantity: 10),
//            Ingredient(id: 48, name: "Sale", quantity: 5),
//            Ingredient(id: 52, name: "Grana", quantity: 25)
//        ],
//        imageUrl: "/static/recipes/carbonara.jpg", 
//        isFavourite: false
//    )
//}
