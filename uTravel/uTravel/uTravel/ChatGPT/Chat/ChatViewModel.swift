//
//  ChatViewViewModel.swift
//  uTravel
//
//  Created by James Flair on 3/15/25.
//
import OpenAI
import Foundation
import FirebaseFirestoreCombineSwift
import FirebaseFirestore
import SwiftUI
import FirebaseAuth
import FirebaseAuthCombineSwift

class ChatViewModel: ObservableObject {
    
    @Published var chat: AppChat?
    @Published var messages: [AppMessage] = []
    @Published var messageText: String = ""
    @Published var selectedModel: ChatModel = .gpt3_5_turbo
    @StateObject var viewModel: ToDoListViewViewModel
    @StateObject var modelView: ChatListViewModel
    let chatId: String
    let userId: String
    @AppStorage("openai_api_key") var apiKey = ""
    
    let db = Firestore.firestore()
    
    
    init(userId: String, chatId: String) {
        self._viewModel = StateObject(wrappedValue: { ToDoListViewViewModel(userId: userId) } ()
        )
        self._modelView = StateObject(wrappedValue: { ChatListViewModel ( userId: userId, chatId: chatId )} ()
        )
        self.userId = userId
        self.chatId = chatId
    }
    
    func fetchData() {

        db.collection("Users")
            .document(userId)
            .collection("Chats")
            .document(chatId)
            .getDocument(as: AppChat.self) { result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.chat = success
                }
            case .failure(let failure):
                print(failure)
            }
        }
        
        db.collection("Users")
            .document(userId)
            .collection("Chats")
            .document(chatId)
            .collection("Messages")
            .order(by:"createdAt")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error)")
                    return
                }
                
                
                DispatchQueue.main.async {
                    self.messages = []
                }
                
                if let documents = querySnapshot?.documents {
                    let fetchedMessages = documents.compactMap({ snapshot -> AppMessage? in
                        do {
                            var message = try snapshot.data(as: AppMessage.self)
                            message.id = snapshot.documentID
                            return message
                        } catch {
                            print("Error decoding message: \(error)")
                            return nil
                        }
                    })

                    DispatchQueue.main.async {
                        self.messages = fetchedMessages
                    }
                }
            }
    }
    
    func sendMessage() async throws {
       
        print(apiKey)
        var newMessage = AppMessage(id: chatId, text: messageText, role: .user, createdAt: FirestoreDate())
        
        do {
            let documentRef = try storeMessage(message: newMessage)
            newMessage.id = documentRef.documentID
        } catch {
            print(error)
        }
        
        if messages.isEmpty {
            setupNewChat()
        }
        
        await MainActor.run { [newMessage] in
            messages.append(newMessage)
            messageText = ""
        }
        
        try await generateResponse(for: newMessage)
        
    }
    
    private func storeMessage(message: AppMessage) throws -> DocumentReference {
        return try db.collection("Users")
            .document(userId)
            .collection("Chats")
            .document(chatId)
            .collection("Messages")
            .addDocument(from: message)
    }
    
    private func setupNewChat() {
        db.collection("Users")
            .document(userId)
            .collection("Chats")
            .document(chatId)
            .updateData(["model": selectedModel.rawValue])
        DispatchQueue.main.async { [weak self] in
            self?.chat?.model = self?.selectedModel
        }
    }
    
    private func generateResponse(for message: AppMessage) async throws {
        let openAI = OpenAI(apiToken: apiKey)
        let queryMessages = messages.map { appMessage in
            Chat(role: appMessage.role, content: appMessage.text)
        }
        let query = ChatQuery(model: chat?.model?.model ?? .gpt3_5Turbo, messages: queryMessages)
        for try await result in openAI.chatsStream(query: query) {
            guard let newText = result.choices.first?.delta.content else { continue }
            await MainActor.run {
                if let lastMessage = messages.last, lastMessage.role != .user {
                    messages[messages.count - 1].text += newText
                } else {
                    let newMessage = AppMessage(id: result.id, text: newText, role: .assistant, createdAt: FirestoreDate())
                    messages.append(newMessage)
                }
            }
        }
        
        if let lastMessage = messages.last {
            _ = try storeMessage(message: lastMessage)
        }
    }
}


struct AppMessage: Identifiable, Codable, Hashable {
    var id: String?
    var text: String
    let role: Chat.Role
    var createdAt: FirestoreDate
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case role
        case createdAt
    }
}
