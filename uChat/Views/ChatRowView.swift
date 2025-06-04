//
//  ChatRowView.swift
//  uTravel
//
//  Created by James Flair on 5/29/25.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth

struct ChatRowView: View {
    let chat: uChat
    @State private var currentUserId = Auth.auth().currentUser?.uid ?? ""
    
    private var otherUserName: String {
        let otherUserId = chat.participants.first { $0 != currentUserId } ?? ""
        return chat.participantNames[otherUserId] ?? "Unknown"
    }
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(otherUserName)
                    .font(.headline)
                    .lineLimit(1)
                
                if let lastMessage = chat.lastMessage {
                    Text(lastMessage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                } else {
                    Text("No messages yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(chat.lastMessageTimestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
