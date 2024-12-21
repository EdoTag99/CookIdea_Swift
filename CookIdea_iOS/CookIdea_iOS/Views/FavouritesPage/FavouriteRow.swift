//
//  FavouriteRow.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 08/08/24.
//

import SwiftUI

struct FavouriteRow: View {
    @Binding var vm: ViewModel
    @Binding var recipe: Recipe
    var body: some View {
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
            }
            
            Spacer()
            
            Button(action: {
                Task {
                    guard let userID = vm.user?.id else {
                        print("invalid user id")
                        throw APIErrors.invalidUserID
                    }
                    
                    if let index = vm.favouriteRecipes.firstIndex(where: { $0.id == recipe.id }) {
                        vm.favouriteRecipes[index].isFavourite = try await vm.FavouriteToggle(recipeId: recipe.id, userId: userID)
                    }
                }
            }){
                if recipe.isFavourite ?? false {
                    Image(systemName: "heart.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                }else{
                    Image(systemName: "heart")
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                }
            }
            .padding()
        }
    }

}

#Preview {
    FavouriteRow(vm: .constant(ViewModel()), recipe: .constant(ViewModel().exampleRecipe!))
}
