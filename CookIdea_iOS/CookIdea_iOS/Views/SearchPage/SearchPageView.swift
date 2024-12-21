//
//  SearchPageView.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 02/06/24.
//

import SwiftUI

struct SearchPageView: View {
    @Binding var vm: ViewModel
    @Binding var userId: Int?
    @Binding var selectedServing: String
    @State private var selectedRecipe: Recipe?
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(8)
                TextField("Search...", text: $vm.Search)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.trailing)
                    .shadow(radius: 5)
                    .onChange(of: vm.Search, initial: true) {
                        Task {
                            if vm.Search.count > 3 {
                                try? await vm.FetchRecipeSearch()
                            }
                        }
                    }
            }
            .padding(.top)
            Spacer()
            if !selectedServing.isEmpty {
                ProgressView()
                    .onAppear {
                        Task {
                            try? await vm.FetchRecipeServings(servingName: selectedServing)
                            selectedServing = ""
                        }
                    }
            } else {
                List(vm.Result){recipe in
                    SearchRow(recipe: recipe, selectedRecipe: $selectedRecipe)
                }
                .padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: -10))
            }
            Spacer()
        }
        .sheet(item: $selectedRecipe) { recipe in
            RecipeDetailView(vm: $vm, recipeID: recipe.id)
                .onDisappear {
                    vm.recipe = nil
                }
        }
        
        
            
    }
}

#Preview {
    SearchPageView(vm: .constant(ViewModel()), userId: .constant(30), selectedServing: .constant("Primo"))
}
