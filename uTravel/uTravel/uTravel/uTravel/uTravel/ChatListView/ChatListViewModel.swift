//
//  ChatListViewModel.swift
//  uTravel
//
//  Created by James Flair on 3/4/25.
//
 
import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import OpenAI

class ChatListViewModel: ObservableObject {
    @DocumentID var id: String?
    @Published var chats: [AppChat] = []
    @FirestoreQuery var items: [AppChat]
    @Published var loadingState: ChatListState = .none
    @Published var isShowingProfileView = false
    @StateObject var viewModel: ToDoListViewViewModel
    private let userId: String
    
    
    let db =  Firestore.firestore()
    
    
    init(userId: String) {
        
            self._items = FirestoreQuery(
                collectionPath: "Users/\(userId)/Chats"
            )
            self._viewModel = StateObject(wrappedValue:ToDoListViewViewModel(userId: userId)
            )
        self.userId = userId
    }
    
    func fetchData(userId: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
//        self.chats = [
//            AppChat(id: "1", topic: "Some Topic", model: .gpt3_5_turbo, lastMessageSent: FirestoreDate(), owner: "123"),
//            AppChat(id: "2", topic: "Some other Topic", model: .gpt4, lastMessageSent: FirestoreDate(), owner: "123")
//        ]
//        self.loadingState = .resultFound
        
        if loadingState == .none {
            loadingState = .loading
            db.collection("Users")
                .document(userId)
                .collection("Chats")
                .whereField("owner", isEqualTo: userId).addSnapshotListener{ [weak self] querySnapshot, err in
                guard let self = self, let documents = querySnapshot?.documents, !documents.isEmpty else {
                    self?.loadingState = .noResults
                    return
                }
                
                self.chats = documents.compactMap({ snapshot -> AppChat? in
                    return try? snapshot.data(as: AppChat.self)
                })
                .sorted(by: {$0.lastMessageSent > $1.lastMessageSent})
                self.loadingState = .resultFound
            }
        }
    }
    
    func createChat(userId: String) async throws -> String {
        let document = try await
        db.collection("Users")
            .document(userId)
            .collection("Chats")
            .addDocument(data: ["lastMessageSent": Date(), "owner": userId])

        return document.documentID
    }
    
    func showProfile() {
        isShowingProfileView = true
    }
    
    func deleteChat(chat : AppChat) {
        
    }
}

enum ChatListState {
    case none
    case loading
    case noResults
    case resultFound
}

struct AppChat: Codable, Identifiable {
    @DocumentID var id: String?
    let topic: String?
    var model: ChatModel?
    let lastMessageSent: FirestoreDate
    let owner: String
    
    var lastMessageTimeAgo: String {
        let now = Date()
        let components = Calendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year], from: lastMessageSent.date, to: now)
        
        let timeUnits: [(value: Int?, unit: String)] = [
            (components.year, "year"),
            (components.month, "month"),
            (components.day, "day"),
            (components.hour, "hour"),
            (components.minute, "minute"),
            (components.second, "second"),
        ]
        
        for timeUnit in timeUnits {
            if let value = timeUnit.value, value > 0 {
                if let value = timeUnit.value, value > 0 {
                    return "\(value) \(timeUnit.unit)\(value == 1 ? "" : "s") ago"
                }
            }
            enum CodingKeys: String, CodingKey {
                case id
                case topic
                case model
                case lastMessageSent
                case owner
            }
        }
        
        return "Just now"
    }
}

enum ChatModel: String, Codable, CaseIterable, Hashable {
    case gpt3_5_turbo = "GPT 3.5 Turbo"
    case gpt4 = "GPT 4"
    
    var tintColor : Color {
        switch self {
        case .gpt3_5_turbo:
            return .green
        case .gpt4:
            return .purple
        }
    }
    
    var model: Model {
        switch self {
        case .gpt3_5_turbo:
            return .gpt3_5Turbo
        case .gpt4:
            return .gpt4
        }
    }
}

struct FirestoreDate: Codable, Hashable, Comparable {
    var date: Date
    
    init (_ date: Date = Date()) {
        self.date = date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let timestamp = try container.decode(Timestamp.self)
        date = timestamp.dateValue()
    }
    
    func encoder(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let timestamp = Timestamp(date: date)
        try container.encode(timestamp)
    }
    
    static func < (lhs: FirestoreDate, rhs: FirestoreDate) -> Bool {
        lhs.date < rhs.date
    }
    

}
