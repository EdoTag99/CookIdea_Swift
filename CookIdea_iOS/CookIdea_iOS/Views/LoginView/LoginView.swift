//
//  LoginView.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 27/07/24.
//

import SwiftUI

struct LoginView: View {
    @Environment (\.dismiss) var dismiss
    @Binding var vm: ViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    var body: some View {
        Image("cookidea_applogo_title")
            .resizable()
            .frame(width: 200, height: 200)
            .padding()
                    
        TextField("Email / Username", text: $username)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .shadow(radius: 5)
            .textInputAutocapitalization(.never)
            

        SecureField("Password", text: $password)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .shadow(radius: 5)
        
        
        Button(action: {
            Task{
                try await vm.loginUser(username: username, password: password)
                if vm.user != nil {
                    dismiss()
                }
            }
            
        }) {
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .frame(height: 40)
                    .padding(.leading)
                    .padding(.trailing)
                Text("Login")
                    .foregroundStyle(.white)
            }
        }
        .disabled(username.isEmpty || password.count < 8)
    
        NavigationLink {
            RegisterView(vm: $vm)
        } label: {
            HStack {
                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .frame(height: 40)
                        .padding(.leading)
                        .padding(.trailing)
                    Text("Register")
                        .foregroundStyle(.white)
                }
            }
        }
        .foregroundStyle(Color.blue)
        .onAppear(perform: {
            if vm.user != nil {
                dismiss()
            }
        })
        
        Text(vm.loginError)
            .padding()
        
        Spacer()
    }
    
}
#Preview {
    LoginView(vm: .constant(ViewModel()))
}
