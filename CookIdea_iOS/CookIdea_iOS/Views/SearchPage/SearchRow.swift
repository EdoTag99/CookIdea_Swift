//
//  SearchRow.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 22/07/24.
//

import SwiftUI

struct SearchRow: View {
    var recipe: Recipe
    @Binding var selectedRecipe: Recipe?
    var body: some View {
        Button(action: {
            selectedRecipe = recipe
        }){
            HStack{
                AsyncImage(url: APIManager().baseUrl.appendingPathComponent(recipe.imageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(5)
                .aspectRatio(contentMode: .fit)
                VStack(alignment: .leading){
                    Text(recipe.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    HStack{
                        Text("Portata:")
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Text(recipe.servingName!)
                            .foregroundColor(.primary)
                    }
                    HStack{
                        Text("Tempo:")
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Text("\(recipe.time!) minuti")
                            .foregroundColor(.primary)
                    }
                    HStack{
                        Text("Difficoltà:")
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Text(getEmoji(difficulty: recipe.difficulty!))
                            .foregroundColor(.primary)
                    }
                }
                Spacer()
            }
        }
    }
    func getEmoji(difficulty: Int) -> String {
        switch difficulty {
        case 1:
            return "😁"
        case 2:
            return "😥"
        case 3:
            return "🥵"
        default:
            return ""
        }
    }
}

#Preview {
    SearchRow(recipe: Recipe(id: 13,name: "Pasta in bianco",difficulty: 1,time: 10,servingName: "Primo",provenance: "Lombardia", description: "No Description", ingredients: [],imageUrl: "/static/recipes/pastainbianco.jpg", isFavourite: true), selectedRecipe: .constant(Recipe(id: 13,name: "Pasta in bianco",difficulty: 1,time: 10,servingName: "Primo",provenance: "Lombardia", description: "No Description", ingredients: [], imageUrl: "/static/recipes/pastainbianco.jpg", isFavourite: false)))
}
