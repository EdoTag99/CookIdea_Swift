//
//  ContentView.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 02/06/24.
//

import SwiftUI

struct ContentView: View {
    @State private var vm = ViewModel()
    @State private var userId: Int? = nil
    @State private var selectedTab: Int = 0
    @State private var selectedServing: String = ""
    @State private var isDrawerOpen: Bool = false
    @State private var presentedProfile: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                isDrawerOpen.toggle()
                            }
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .resizable()
                                .frame(width: 25, height: 15)
                                .padding(.leading)
                                .frame(alignment: .leading)
                        }
                        
                        Spacer()
                        
                        Image("cookidea_applogo")
                            .resizable()
                            .frame(width: 50, height: 45)
                        
                        Spacer()
                        
                        if vm.user != nil {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.trailing)
                                .foregroundStyle(.blue)
                                .onTapGesture {
                                    presentedProfile = true
                                }
                                .sheet(isPresented: $presentedProfile){
                                    UserProfileView(vm: $vm, isPresented: $presentedProfile)
                                }
                        } else {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.trailing)
                                .foregroundStyle(Color(.systemBackground))
                        }
                        
                        
                        
                    }
                    .padding()
                    .frame(height: 30)
                    
                    
                    ZStack() {
                        // Main content
                        TabView(selection: $selectedTab) {
                            HomePageView(selectedTab: $selectedTab, selectedServing: $selectedServing)
                                .tabItem {
                                    Label("Home", systemImage: "house")
                                }
                                .tag(0)
                            SearchPageView(vm: $vm, userId: $userId, selectedServing: $selectedServing)
                                .tabItem {
                                    Label("Search", systemImage: "magnifyingglass")
                                }
                                .tag(1)
                            ShoppingListPageView(userId: $userId)
                                .tabItem {
                                    Label("Shopping", systemImage: "list.bullet")
                                }
                                .tag(2)
                            WeeklyMenuPageView(userId: $userId)
                                .tabItem {
                                    Label("Menu", systemImage: "menucard")
                                }
                                .tag(3)
                        }
                    }
                }
                if isDrawerOpen {
                    HStack {
                        DrawerView(vm: $vm, isDrawerOpen: $isDrawerOpen)
                            .frame(width: 200)
                            .background(Color(.systemBackground))
                            .transition(.move(edge: .trailing))
                            .shadow(radius: 10)
                        
                        Color.black.opacity(0.01)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                isDrawerOpen = false
                            }
                    }
                    
                }
            }
            .onAppear(perform: {
                if vm.user != nil {
                    userId = vm.user?.id
                }
            })
        }
    }
        
}

#Preview {
    ContentView()
}
