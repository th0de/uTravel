//
//  ContentView.swift
//  uTravel
//
//  Created by James Flair on 12/23/24.
//
import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = MainViewViewModel()
    
    var body: some View {
        if viewModel.isLoggedIn, !viewModel.currentUserId.isEmpty {
            accountView
        } else {
            LoginView()
        }
    }
    
    @ViewBuilder
    var accountView: some View {
        TabView {
            ToDoListView(userId: viewModel.currentUserId)
                .tabItem{
                    Label("Home", systemImage:"house")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage:"person.circle")
                }
            
            AirbnbListingsVeiw()
                .tabItem {
                    Label("AirBnB", systemImage: "house.lodge.fill")
                }
            
            ChatListView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("ChatGPT", systemImage: "cpu")
                }
        }
    }
    
    struct ContentView_Previews: PreviewProvider{
        static var previews: some View {
            MainView()
        }
    }
}
