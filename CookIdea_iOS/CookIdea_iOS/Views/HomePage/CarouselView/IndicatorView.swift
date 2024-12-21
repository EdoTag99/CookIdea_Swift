//
//  IndicatorView.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 18/07/24.
//

import SwiftUI

struct IndicatorView: View {
    let imageCount: Int
    @Binding var scrollID: Int?
    var body: some View {
        HStack {
            ForEach(0..<imageCount, id: \.self) { indicator in
                let index = scrollID ?? 0
                Button {
                    withAnimation {
                        scrollID = indicator
                    }
                } label: {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .foregroundStyle(indicator == index ? Color.white : Color(.lightGray))
                }
            }
        }
        .padding(5)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.lightGray)).opacity(0.2))
    }
}

