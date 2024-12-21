//
//  ShoppingListPageView.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 02/06/24.
//

import SwiftUI

struct ShoppingListPageView: View {
    @Binding var userId: Int?
    var body: some View {
        Text("ShppingListPage")
    }
}

#Preview {
    ShoppingListPageView(userId: .constant(30))
}
