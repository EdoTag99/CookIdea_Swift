//
//  HomePageView.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 02/06/24.
//

import SwiftUI

struct HomePageView: View {
    @State private var vm = ViewModel()
    @Binding var selectedTab: Int
    @Binding var selectedServing: String
    var body: some View {
        VStack {
            Spacer()
            
            if vm.Carousel.isEmpty {
                ProgressView()
                    .onAppear {
                        Task {
                            try? await vm.FetchCarouselRecipe()
                        }
                    }
            } else {
                CarouselView(carouselRecipe: vm.Carousel)
            }
            
            Spacer()
            
            if vm.Servings.isEmpty {
                ProgressView()
                    .onAppear {
                        Task {
                            try? await vm.FetchServings()
                        }
                    }
            } else {
                ForEach(vm.Servings) { serving in
                    Button (action: {
                        selectedTab = 1
                        selectedServing = serving.name
                    }){
                        ServingRow(serving: serving)
                            .padding(EdgeInsets(top: -5, leading: 0, bottom: -5, trailing: 0))
                    }
                }
            }
        }
    }
}


extension ServingRow {
    init(serving: Serving){
        servingName = serving.name
        servingImageURL = serving.imageUrl
    }
}



#Preview {
    HomePageView(selectedTab: .constant(0), selectedServing: .constant(""))
}
