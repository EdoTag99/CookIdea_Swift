//
//  ContentViewModel.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 27/07/24.
//

import Foundation

@Observable class ViewModel {
    var user: User?
    var Search: String = ""
    var Result: [Recipe] = []
    var Servings: [Serving] = []
    var Carousel: [Recipe] = []
    var recipe: Recipe?
    var loginError: String = ""
    var favouriteRecipes: [Recipe] = []
    var meals: [Meal] = []
    
    
    func loginUser(username: String, password: String) async throws{
        var request = URLRequest(url: APIManager().login)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["username": username, "password": password]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIErrors.serverError
        }
        
        guard httpResponse.statusCode == 200 else {
            guard httpResponse.statusCode == 403 else {
                loginError = "Unexpected Server Error"
                throw APIErrors.serverError
            }
            loginError = "Wrong Username or Password"
            throw APIErrors.loginError
        }
                
        do {
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let decodedUser = try decoder.decode(User.self, from: data)
            user.self = decodedUser
            loginError = ""
        } catch {
            print(error)
            throw APIErrors.decodingError
        }
    }
    
    func registerUser(name: String, surname: String, email: String, birthdate: Date, username: String, password: String) async throws{
        var request = URLRequest(url: APIManager().register)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["name": name, "surname": surname, "email": email, "birthDate": birthdate.ISO8601Format(), "username": username, "password": password]
        print(name, surname, email, birthdate, username, password)
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIErrors.serverError
        }
        
        guard httpResponse.statusCode == 200 else {
            guard httpResponse.statusCode == 403 else {
                throw APIErrors.serverError
            }
            throw APIErrors.loginError
        }
        
        do {
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let decodedUser = try decoder.decode(User.self, from: data)
            
            user.self = decodedUser
        } catch {
            print(error)
            throw APIErrors.decodingError
        }
    }
    

    func FetchRecipeServings(servingName: String) async throws{
        let (data, response) = try await URLSession.shared.data(from: APIManager().servingRecipes.appending(queryItems: [URLQueryItem(name: "serving", value: servingName)]))
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIErrors.serverError
        }
        
        do {
            let decodedRecipes = try JSONDecoder().decode([Recipe].self, from: data)
            DispatchQueue.main.async {
                self.Result = decodedRecipes
            }
        } catch {
            throw APIErrors.decodingError
        }
    }
    
    func FetchRecipeSearch() async throws{
        let (data, response) = try await URLSession.shared.data(from: APIManager().recipeSearch.appending(queryItems: [URLQueryItem(name: "recipeName", value: Search)]))
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIErrors.serverError
        }
        
        do {
            let decodedRecipes = try JSONDecoder().decode([Recipe].self, from: data)
            DispatchQueue.main.async {
                self.Result = decodedRecipes
            }
        } catch {
            throw APIErrors.decodingError
        }
    }
    
    
    func FetchServings() async throws{
        let (data, response) = try await URLSession.shared.data(from: APIManager().servings)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIErrors.serverError
        }
        
        do {
            let decodedServings = try JSONDecoder().decode([Serving].self, from: data)
            DispatchQueue.main.async {
                self.Servings = decodedServings
            }
        } catch {
            throw APIErrors.decodingError
        }
    }
    
    func FetchCarouselRecipe() async throws{
        let (data, response) = try await URLSession.shared.data(from: APIManager().carouselImages)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIErrors.serverError
        }
        
        do {
            let decodedCarouselRecipe = try JSONDecoder().decode([Recipe].self, from: data)
            DispatchQueue.main.async {
                self.Carousel = decodedCarouselRecipe
            }
        } catch {
            throw APIErrors.decodingError
        }
    }
    
    func FetchRecipeDetails(recipeID: Int) async throws{
        let (data, response) = try await URLSession.shared.data(from: APIManager().recipeByID.appending(queryItems: [URLQueryItem(name: "recipeID", value: "\(recipeID)")]))
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIErrors.serverError
        }
        
        do {
            let decodedRecipe = try JSONDecoder().decode(Recipe.self, from: data)
            DispatchQueue.main.async {
                self.recipe = decodedRecipe
            }
        } catch {
            throw APIErrors.decodingError
        }
    }
    
    func FetchFavouriteRecipe(recipeId: Int, userId: Int) async throws /*-> Bool*/{
        let (data, response) = try await URLSession.shared.data(from: APIManager().isRecipeFavourite.appending(queryItems: [URLQueryItem(name: "recipeID", value: "\(recipeId)"), URLQueryItem(name: "userID", value: "\(userId)")]))
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIErrors.serverError
        }
        
        do {
            let isFavourite = try JSONDecoder().decode(Bool.self, from: data)
            DispatchQueue.main.async {
                self.recipe?.isFavourite = isFavourite
            }
            //return isFavourite
        } catch {
            throw APIErrors.decodingError
        }
    }
    
    func FavouriteToggle(recipeId: Int, userId: Int) async throws -> Bool{
        let (data, response) = try await URLSession.shared.data(from: APIManager().toggleFavourite.appending(queryItems: [URLQueryItem(name: "userID", value: "\(userId)"), URLQueryItem(name: "recipeID", value: "\(recipeId)")]))
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIErrors.serverError
        }
        
        do {
            let isFavourite = try JSONDecoder().decode(Bool.self, from: data)
//            DispatchQueue.main.async {
//                self.recipe?.isFavourite = isFavourite
//            }
            return isFavourite
        } catch {
            throw APIErrors.decodingError
        }
    }
    
    func FetchFavouriteRecipes(userId: Int) async throws{
        let (data, response) = try await URLSession.shared.data(from: APIManager().favouriteRecipes.appending(queryItems: [URLQueryItem(name: "userID", value: "\(userId)")]))
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIErrors.serverError
        }
        
        do {
            let favourites = try JSONDecoder().decode([Recipe].self, from: data)
            DispatchQueue.main.async {
                self.favouriteRecipes = favourites
            }
        } catch {
            throw APIErrors.decodingError
        }
    }
    
    func FetchWeeklyMenu(userId: Int) async throws{
        let (data, response) = try await URLSession.shared.data(from: APIManager().weeklyMenu.appending(queryItems: [URLQueryItem(name: "userID", value: "\(userId)")]))
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIErrors.serverError
        }
        
        do {
            let favourites = try JSONDecoder().decode([Recipe].self, from: data)
            DispatchQueue.main.async {
                self.favouriteRecipes = favourites
            }
        } catch {
            throw APIErrors.decodingError
        }
    }
    
    func AddWeeklyMenu(userId: Int, recipeId: Int, mealId: Int, date: String) async throws -> Bool{
        let (data, response) = try await URLSession.shared.data(from: APIManager().addWeeklyMenu.appending(queryItems: [URLQueryItem(name: "userID", value: "\(userId)"), URLQueryItem(name: "recipeID", value: "\(recipeId)"), URLQueryItem(name: "mealID", value: "\(mealId)"), URLQueryItem(name: "menuDate", value: date)]))
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIErrors.serverError
        }
        
        do {
            let added = try JSONDecoder().decode(Bool.self, from: data)
//            DispatchQueue.main.async {
//                self.favouriteRecipes = favourites
//            }
            return added
        } catch {
            throw APIErrors.decodingError
        }
    }
    
    func FetchMeals() async throws{
        let (data, response) = try await URLSession.shared.data(from: APIManager().meals)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIErrors.serverError
        }
        
        do {
            let decodedMeals = try JSONDecoder().decode([Meal].self, from: data)
            DispatchQueue.main.async {
                self.meals = decodedMeals
            }
        } catch {
            throw APIErrors.decodingError
        }
    }
    
    
    
    let exampleRecipe: Recipe? = Recipe(
        id: 1,
        //name: "Pasta alla Carbonara",
        name: "Risotto ai funghi porcini",
        difficulty: 2,
        time: 20,
        servingName: "Primo",
        provenance: "Lazio",
        description: "Mettiamo l’acqua per la pasta sul fuoco e nel frattempo preparate il condimento. Saltiamo in padella il guanciale insieme a un filo d’olio per un paio di minuti, quindi spegniamo il fuoco e mettiamo da parte.\nIn una terrina capiente sgusciamo l’uovo intero e aggiungiamo anche il tuorlo, i formaggi grattugiati e abbondante pepe. Lavoriamo tutti gli ingredienti con una frusta fino a ottenere un composto cremoso e ben amalgamato.\nCuociamo gli spaghetti in acqua salata e scoiamoli al dente direttamente nella ciotola delle uova. Aggiungiamo i cubetti di guanciale e mantechiamo velocemente la pasta.\n",
        ingredients: [
            Ingredient(id: 55, name: "Spaghetti", quantity: 200),
            Ingredient(id: 54, name: "Guanciale", quantity: 100),
            Ingredient(id: 47, name: "Pepe", quantity: 5),
            Ingredient(id: 53, name: "Uova", quantity: 2),
            Ingredient(id: 51, name: "Pecorino", quantity: 25),
            Ingredient(id: 49, name: "Olio", quantity: 10),
            Ingredient(id: 48, name: "Sale", quantity: 5),
            Ingredient(id: 52, name: "Grana", quantity: 25)
        ],
        imageUrl: "/static/recipes/carbonara.jpg",
        isFavourite: false
    )

    
    let testUser: User =
    User(id: 0,
         name: "Edoardo",
         surname: "Tagliani",
         birthDate: Date(),
         email: "edoardo.tagliani@test.com",
         username: "EdoTag",
         password: "1234567890")
}
