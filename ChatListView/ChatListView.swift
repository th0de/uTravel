 //
//  ChatListView.swift
//  uTravel
//
//  Created by James Flair on 3/4/25.
//

import SwiftUI
import Foundation
import FirebaseFirestore

struct ChatListView: View {
    @StateObject var viewModel = ChatListViewModel(userId: "")
    @EnvironmentObject var appState : MainViewViewModel
    @FirestoreQuery var items: [AppChat]
   private let userId: String = ""
    
    init(userId: String) {
        self._items = FirestoreQuery(
            collectionPath: "Users/\(userId)/Chats"
        )
        self._viewModel = StateObject(wrappedValue:ChatListViewModel(userId: userId)
        )
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
                                let chatId = try await  viewModel.createChat(userId:appState.currentUserId)
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
                ChatView(viewModel: .init(chatId: chatId))
            })
            .onAppear {
                if viewModel.loadingState == .none {
                    viewModel.fetchData(userId: appState.currentUserId)
                }
            }
        }
    }
}
    
    struct ChatListView_Previews: PreviewProvider{
        static var previews: some View{
            ChatListView(userId: "")
        }
    }

