//
//  ServingRow.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 02/06/24.
//

import SwiftUI

struct ServingRow: View {
    let servingName: String
    let servingImageURL: String
    var body: some View {
        ZStack {
                AsyncImage(url: APIManager().baseUrl.appendingPathComponent(servingImageURL)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(5)
                .aspectRatio(contentMode: .fit)
                
            
            Text(servingName)
                .foregroundStyle(.white)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .font(.largeTitle)
                .fontWeight(.black)
        }
    }
}

#Preview {
    ServingRow(servingName: "Primo", servingImageURL: "/static/img/primo.jpg")
}
