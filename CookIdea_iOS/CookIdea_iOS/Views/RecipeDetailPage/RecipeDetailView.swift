//
//  RecipeDetailView.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 22/07/24.
//

import SwiftUI

struct RecipeDetailView: View {
    @State var isFavourite: Bool?
    @State var selectedMeal: Int = 0
    @Binding var vm: ViewModel
    @State private var selectedDayIndex = 0
    @State private var result: Bool? = nil
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    var recipeID: Int
    var orderedWeekDays: [String] {
        let days = Calendar.current.weekdaySymbols
        let todayIndex = Calendar.current.component(.weekday, from: Date()) - 1
        let firstPart = Array(days[todayIndex...])
        let secondPart = Array(days[..<todayIndex])
        return firstPart + secondPart
    }
    var selectedDate: Date {
        let todayIndex = Calendar.current.component(.weekday, from: Date()) - 1
        let dayOffset = (selectedDayIndex - todayIndex + 7) % 7
        return Calendar.current.date(byAdding: .day, value: dayOffset, to: Date()) ?? Date()
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: selectedDate)
    }
    var body: some View {
        if let recipe = vm.recipe{
            Text(recipe.name)
                .fontWeight(.bold)
                .font(.title)
                .shadow(radius: 10)
            VStack(alignment: .leading){
                AsyncImage(url: APIManager().baseUrl.appendingPathComponent(recipe.imageUrl)){ image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .aspectRatio(contentMode: .fit)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                
                .padding(.leading, 5)
                .padding(.trailing, 5)
                GeometryReader { geometry in
                    ScrollView(){
                        HStack {
                            VStack(alignment: .leading) {
                                HStack{
                                    Text("Origine:")
                                        .fontWeight(.bold)
                                        .shadow(radius: 10)
                                    Text(recipe.provenance!)
                                }
                                .font(.title3)
                                
                                HStack{
                                    Text("Portata:")
                                        .fontWeight(.bold)
                                        .shadow(radius: 10)
                                    Text(recipe.servingName!)
                                }
                                .font(.title3)
                                
                                HStack{
                                    Text("Tempo:")
                                        .fontWeight(.bold)
                                        .shadow(radius: 10)
                                    Text("\(recipe.time!) minuti")
                                }
                                .font(.title3)
                                
                                HStack{
                                    Text("Difficoltà:")
                                        .fontWeight(.bold)
                                        .shadow(radius: 10)
                                    Text(getEmoji(difficulty: recipe.difficulty!))
                                }
                                .font(.title3)
                            }
                            .frame(maxWidth: geometry.size.width, alignment: .leading)
                            .padding(.leading, 5)
                            .padding(.trailing, 5)
                            
                            if vm.user != nil {
                                Button(action: {
                                    Task {
                                        guard let userId = vm.user?.id else {
                                            print("invalid user id")
                                            throw APIErrors.invalidUserID
                                        }
                                        isFavourite = try await vm.FavouriteToggle(recipeId: recipe.id, userId: userId)
                                    }
                                }){
                                    if recipe.isFavourite ?? false {
                                        Image(systemName: "heart.fill")
                                            .font(.largeTitle)
                                            .foregroundStyle(.red)
                                            .padding()
                                    }else{
                                        Image(systemName: "heart")
                                            .font(.largeTitle)
                                            .foregroundStyle(.red)
                                            .padding()
                                    }
                                }
                            }
                        }
                        
                        
                        if vm.user != nil {
                            Text("Aggiungi al menù settimanale:")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                            
                            HStack(alignment: .center) {
                                
                                Spacer()
                                
                                VStack {
                                    Picker("Seleziona un giorno", selection: $selectedDayIndex) {
                                        ForEach(0..<orderedWeekDays.count, id: \.self) { index in
                                            Text(orderedWeekDays[index])
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .padding(.trailing)
                                                                        
                                    Picker("Seleziona un pasto", selection: $selectedMeal) {
                                        ForEach(0..<vm.meals.count, id: \.self) { index in
                                            Text(vm.meals[index].name)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .padding(.trailing)
                                    .onAppear {
                                        Task {
                                            try await vm.FetchMeals()
                                        }
                                    }
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    Task {
                                        guard let userID = vm.user?.id else {
                                            return
                                        }
                                        result = try await vm.AddWeeklyMenu(userId: userID, recipeId: recipeID, mealId:vm.meals[selectedMeal].id, date: formattedDate)
                                    }
                                }, label: {
                                    ZStack{
                                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                            .frame(width: 100, height: 40)
                                            .padding(.leading)
                                            .padding(.trailing)
                                        Text("Aggiungi")
                                            .foregroundStyle(.white)
                                    }
                                })
                                
                                Spacer()
                            }
                        }
                        
                        Text("Ingredienti:")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                        
                        VStack(alignment: .leading){
                            ForEach(recipe.ingredients!){ingredient in
                                HStack{
                                    Text("\(ingredient.name): \(ingredient.quantity)")
                                        .font(.title3)
                                }
                            }
                        }
                        .frame(maxWidth: geometry.size.width, alignment: .leading)
                        .padding(.leading, 5)
                        .padding(.trailing, 5)
                        
                        Text("Procedimento:")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                        
                        Text(recipe.description!)
                            .font(.title3)
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                    }
                }
            }
            .onChange(of: result) {
                guard result != nil else {
                    return
                }
                alertMessage = result! ? "Ricetta Aggiunta" : "Impossibile aggiungere la ricetta"
                showAlert = true
                result = nil
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            
        } else {
            ProgressView()
                .task{
                    try? await vm.FetchRecipeDetails(recipeID: recipeID)
                    guard let userId = vm.user?.id else {
                        return
                    }
                    try? await vm.FetchFavouriteRecipe(recipeId: recipeID, userId: userId)
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
    RecipeDetailView(isFavourite: true, vm: .constant(ViewModel()), recipeID: 1)
}
