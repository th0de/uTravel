 //
//  ChatListView.swift
//  uTravel
//
//  Created by James Flair on 3/4/25.
//

import SwiftUI
import Foundation
import FirebaseFirestoreCombineSwift
import FirebaseFirestore


struct ChatListView: View {
    @StateObject var viewModel = ChatListViewModel(userId: "", chatId: "")
    @EnvironmentObject var appState : MainViewViewModel
    let userId: String
    let chatId: String
    
    init(userId: String, chatId: String) {
        self._viewModel = StateObject(wrappedValue: { ChatListViewModel(userId: userId, chatId: chatId) } ()
        )
        self.userId = userId
        self.chatId = chatId
    }
    
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.loadingState {
                case .loading, .none:
                    Text("Loading Chats...")
                case .noResults:
                    Text("No Results Found")
                case .resultFound:
                    List {
                        ForEach(viewModel.chats) { chat in
                            NavigationLink(value: chat.id) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text( chat.topic ?? "")
                                            .font(.headline)
                                        Spacer()
                                        Text(chat.model?.rawValue ?? "")
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(chat.model?.tintColor ?? .black)
                                            .padding(6)
                                            .clipShape(Capsule(style: .continuous))
                                    }
                                    Text(chat.lastMessageTimeAgo)
                                }    .font(.caption)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.deleteChat(chat: chat)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Chats")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showProfile()
                    } label: {
                        Image(systemName: "person")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        Task{
                            do {
                                let chatId = try await  viewModel.createChat(userId: viewModel.userId)
                                appState.navigationPath.append(chatId)
                            } catch {
                                print(error)
                            }
                            
                        }
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            })
            .sheet(isPresented: $viewModel.isShowingProfileView) {
                ProfileView()
            }
            .navigationDestination(for: String.self, destination: { chatId in
                ChatView(userId:userId, chatId: chatId)
            })
            .onAppear {
                if viewModel.loadingState == .none {
                    viewModel.fetchData(userId: viewModel.userId)
                }
            }
        }
    }
}
    
    struct ChatListView_Previews: PreviewProvider{
        static var previews: some View{
            ChatListView(userId: "", chatId: "")
        }
    }
