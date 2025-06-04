//
//  uChatListView.swift
//  uTravel
//
//  Created by James Flair on 5/28/25.
//

import SwiftUI
import FirebaseAuth


struct uChatListView: View {
    @StateObject private var viewModel = uChatListViewModel()
    @State private var showingNewChatSheet = false
    @State private var navigateToChat = false
    @State private var selectedChat: uChat?
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("Chats")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        newChatButton
                    }
                }
                .sheet(isPresented: $showingNewChatSheet) {
                    newChatSheet
                }
                .background(navigationLink)
        }
    }
    
    
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.chats.isEmpty {
            loadingView
        } else if viewModel.chats.isEmpty {
            emptyStateView
        } else {
            chatsList
        }
    }
    
    private var loadingView: some View {
        ProgressView("Loading chats...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No conversations yet")
                .font(.title2)
                .foregroundColor(.gray)
            
            Button("Start a new chat") {
                showingNewChatSheet = true
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var chatsList: some View {
        List {
            ForEach(viewModel.chats) { chat in
                ChatRowView(chat: chat)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedChat = chat
                    }
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    viewModel.deleteChat(viewModel.chats[index])
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var newChatButton: some View {
        Button {
            showingNewChatSheet = true
        } label: {
            Image(systemName: "square.and.pencil")
        }
    }
    
    private var newChatSheet: some View {
        NewChatView { userId, userName in
            viewModel.createNewChat(with: userId, userName: userName) { result in
                if case .success(let chat) = result {
                    selectedChat = chat
                    showingNewChatSheet = false
                }
            }
        }
    }
    
    private var navigationLink: some View {
        NavigationLink(
            destination: destinationView,
            isActive: Binding(
                get: { selectedChat != nil },
                set: { if !$0 { selectedChat = nil } }
            )
        ) {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var destinationView: some View {
        if let chat = selectedChat,
           let currentUserId = Auth.auth().currentUser?.uid {
            let otherUserId = chat.participants.first { $0 != currentUserId } ?? ""
            let otherUserName = chat.participantNames[otherUserId] ?? "Unknown"
            
            uChatView(
                chatId: chat.id,
                otherUserId: otherUserId,
                otherUserName: otherUserName
            )
        }
    }
}

struct uChatListPreview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            uChatListView()
        }
    }
}

