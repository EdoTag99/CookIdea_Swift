//
//  RegisterView.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 03/08/24.
//

import SwiftUI

struct RegisterView: View {
    @Environment (\.dismiss) var dismiss
    @Binding var vm: ViewModel
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var birthDate: Date = Date()
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Image("cookidea_applogo_title")
            
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .shadow(radius: 5)
            
            TextField("Surname", text: $surname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .shadow(radius: 5)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .shadow(radius: 5)
                .textInputAutocapitalization(.never)
            
            DatePicker("BirthDate", selection: $birthDate, displayedComponents: [.date])
                .padding(.leading)
                .padding(.trailing)
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .shadow(radius: 5)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .shadow(radius: 5)
            
            Spacer()
            
            Button(action: {
                Task{
                    try await vm.registerUser(name: name, surname: surname, email: email, birthdate: birthDate, username: username, password: password)
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
                    Text("Register")
                        .foregroundStyle(.white)
                }
            }
            .disabled(name.isEmpty || surname.isEmpty || email.isEmpty || !email.contains("@") || !email.contains(".") || username.isEmpty || password.count < 8)
        }
    }
}

#Preview {
    RegisterView(vm: .constant(ViewModel()))
}
