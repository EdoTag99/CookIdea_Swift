//
//  FavouritesView.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 08/08/24.
//

import SwiftUI

struct FavouritesView: View {
    @Binding var vm: ViewModel
    var body: some View {
        if vm.user == nil {
            VStack(alignment: .center){
                Text("Please Login First")
                    .font(.title3)
                    .padding(.bottom, 20)
                NavigationLink {
                    LoginView(vm: $vm)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .frame(height: 40)
                            .padding(.leading)
                            .padding(.trailing)
                        Text("Login")
                            .foregroundStyle(.white)
                    }
                }
                .foregroundStyle(Color.blue)
            }
        } else {
            if vm.favouriteRecipes.isEmpty {
                ProgressView()
                    .onAppear {
                        Task {
                            guard let userId = vm.user?.id else {
                                return
                            }
                            try await vm.FetchFavouriteRecipes(userId: userId)
                        }
                    }
            } else {
                List($vm.favouriteRecipes, id: \.id){ $recipe in
                    FavouriteRow(vm: $vm, recipe: $recipe)
                }
                .padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: -10))
                .onDisappear {
                    vm.favouriteRecipes = []
                }
            }
        }
        
    }
}

#Preview {
    FavouritesView(vm: .constant(ViewModel()))
}
