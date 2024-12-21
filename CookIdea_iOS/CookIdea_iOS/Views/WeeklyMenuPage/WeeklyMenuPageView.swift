//
//  WeeklyMenuPageView.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 02/06/24.
//

import SwiftUI

struct WeeklyMenuPageView: View {
    @Binding var userId: Int?
    var body: some View {
        Text("WeeklyMenuPage")
    }
}

#Preview {
    WeeklyMenuPageView(userId: .constant(30))
}
