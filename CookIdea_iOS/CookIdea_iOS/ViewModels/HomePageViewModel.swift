//
//  HomePageViewModel.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 18/07/24.
//

import Foundation

//@Observable class HomePageViewModel {
//    var Servings: [Serving] = []
//    var Carousel: [Recipe] = []
//    
//    func FetchServings() async throws{
//        let (data, response) = try await URLSession.shared.data(from: APIManager().servings)
//        guard let httpResponse = response as? HTTPURLResponse,
//              httpResponse.statusCode == 200 else {
//            throw APIErrors.serverError
//        }
//        
//        do {
//            let decodedServings = try JSONDecoder().decode([Serving].self, from: data)
//            DispatchQueue.main.async {
//                self.Servings = decodedServings
//            }
//        } catch {
//            throw APIErrors.decodingError
//        }
//    }
//    
//    func FetchCarouselRecipe() async throws{
//        let (data, response) = try await URLSession.shared.data(from: APIManager().carouselImages)
//        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            throw APIErrors.serverError
//        }
//        
//        do {
//            let decodedCarouselRecipe = try JSONDecoder().decode([Recipe].self, from: data)
//            DispatchQueue.main.async {
//                self.Carousel = decodedCarouselRecipe
//            }
//        } catch {
//            throw APIErrors.decodingError
//        }
//    }
//}
