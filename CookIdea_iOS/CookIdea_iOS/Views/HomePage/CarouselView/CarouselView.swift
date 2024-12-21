//
//  CarouselView.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 18/07/24.
//

import SwiftUI

struct CarouselView: View {
    var carouselRecipe: [Recipe]
    @State private var scrollID: Int?
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(0..<carouselRecipe.count, id: \.self) { index in
                            let carouselItem = carouselRecipe[index]
                            VStack {
                                AsyncImage(url: APIManager().baseUrl.appendingPathComponent(carouselItem.imageUrl)) { image in
                                    image
                                        .resizable()
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .shadow(radius: 2)
                                        .padding(5)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            .containerRelativeFrame(.horizontal)
                            .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.6)
                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.6)
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $scrollID)
                .scrollTargetBehavior(.paging)
                IndicatorView(imageCount: carouselRecipe.count, scrollID: $scrollID)
                    .padding(.top, -5)
            }
        }
    }
}



#Preview {
    CarouselView(carouselRecipe: [
        Recipe(id: 0, name: "Lasagna", imageUrl: "/static/recipes/lasagna.jpg"),
        Recipe(id: 1, name: "Mozzarella in Carrozza", imageUrl: "/static/recipes/mozzarellacarrozza.jpg")
    ])
}
