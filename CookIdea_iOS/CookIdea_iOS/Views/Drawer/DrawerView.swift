//
//  DrawerView.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 22/07/24.
//

import SwiftUI

struct DrawerView: View {
    @Binding var vm: ViewModel
    @Binding var isDrawerOpen: Bool
    var body: some View {
        VStack(alignment: .center) {
            ZStack{
                Image("cookidea_applogo_title")
                    .resizable()
                    .frame(width:200, height: 200)
            }
            .onAppear {
                isDrawerOpen = true
            }
            
            if vm.user == nil {
                NavigationLink {
                    LoginView(vm: $vm)
                } label: {
                    HStack {
                        Text("Login")
                        Image(systemName: "person.badge.key")
                    }
                    .font(.title2)
                    .padding(.top, 10)
                }
                .foregroundStyle(Color.blue)
                
            } else {
                Button(action: {
                    vm.user = nil
                }) {
                    Text("Logout")
                        .font(.title2)
                        .padding(.top, 10)
                }
                
                NavigationLink {
                    FavouritesView(vm: $vm)
                } label: {
                    HStack {
                        Text("Preferiti")
                        Image(systemName: "heart")
                    }
                    .font(.title2)
                    .padding(.top, 10)
                }
                .foregroundStyle(Color.blue)
            }
            
            Button(action: {
            }) {
                Text("Altro")
                    .font(.title2)
                    .padding(.top, 10)
            }
            Spacer()
        }
        .padding(.top)
    }
}


#Preview {
    DrawerView(vm: .constant(ViewModel()), isDrawerOpen: .constant(false))
}
