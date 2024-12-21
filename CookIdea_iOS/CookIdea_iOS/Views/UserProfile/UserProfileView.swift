//
//  UserProfileView.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 26/07/24.
//

import SwiftUI

struct UserProfileView: View {
    @Binding var vm: ViewModel
    @Binding var isPresented: Bool
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    isPresented = false
                }, label: {
                    Text("Done")
                        .fontWeight(.bold)
                        .padding(10)
                })
            }
        }
        
        VStack{
            if let username = vm.user?.username {
                Text(username)
                .font(.title)
                .bold()
            } else {
                Text("Error")
                .font(.title)
                .bold()            }
        }
        .padding(.bottom, 10)

        
        VStack(alignment: .leading){
            HStack{
                Spacer()
            }
            
            HStack{
                Text("Nome:")
                .font(.title3)
                .fontWeight(.bold)
                if let name = vm.user?.name {
                    Text(name)                      .font(.title3)
                } else {
                    Text("Error")
                        .font(.title3)
                }
            }
            .padding(.leading, 10)
            .padding(.bottom, 10)
            
            HStack{
                Text("Cognome:")
                    .font(.title3)
                    .fontWeight(.bold)
                if let surname = vm.user?.surname {
                    Text(surname)
                        .font(.title3)
                } else {
                    Text("Error")
                        .font(.title3)
                }
            }
            .padding(.leading, 10)
            .padding(.bottom, 10)
            
            HStack{
                Text("Data di Nascita:")
                    .font(.title3)
                    .fontWeight(.bold)
                if let birthDate = vm.user?.birthDate {
                    Text(birthDate.formatted(.dateTime.year().month().day()))
                    .font(.title3)
                } else {
                    Text("Error")
                    .font(.title3)
                }
            }
            .padding(.leading, 10)
            .padding(.bottom, 10)
            
            HStack{
                Text("E-Mail:")
                    .font(.title3)
                    .fontWeight(.bold)
                if let mail = vm.user?.email {
                    Text(mail)
                        .font(.title3)
                } else {
                    Text("Error")
                        .font(.title3)
                }
            }
            .padding(.leading, 10)
            .padding(.bottom, 10)
            
            Spacer()
        }
    }
}

#Preview {
    UserProfileView(vm: .constant(ViewModel()), isPresented: .constant(true))
}
