//
//  ContentView.swift
//  uTravel
//
//  Created by James Flair on 12/23/24.
//
import SwiftUI

struct MainView: View {
     var userId: String
    @StateObject var viewModel = MainViewViewModel()
    @StateObject var modelView = ChatViewModel(userId: "", chatId: "")
    
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
            HomeView()
                .tabItem{
                    Label("Home", systemImage:"house")
                }
            
            ToDoListView(userId: viewModel.currentUserId)
                .tabItem{
                    Label("Todo", systemImage:"pencil.and.list.clipboard.rtl")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage:"person.circle")
                }
            
            ChatListView( userId: viewModel.currentUserId, chatId: modelView.chatId)
                .environmentObject(viewModel)
                .tabItem {
                    Label("ChatGPT", systemImage: "cpu")
                }
            
            TripAdvisorListingsView()
                .tabItem {
                    Label("TripAdvisor", systemImage: "map")
                }
            
            uChatListView()
                .tabItem {
                    Label("uChat", systemImage: "message")
                }
        }
    }
    
    struct ContentView_Previews: PreviewProvider{
        static var previews: some View {
            MainView(userId: "")
        }
    }
}
