//
//  MessageView.swift
//  uTravel
//
//  Created by James Flair on 4/28/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageView: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser() {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(message.text)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    Text(message.createdAt, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(alignment: .leading) {
                    HStack {
                        Text(message.senderName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    Text(message.text)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(16)
                    Text(message.createdAt, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }
    }
}



struct MessageViewPreviews: PreviewProvider {
    static var previews: some View {
        MessageView(message:Message(id: "", chatId: "", senderId: "", senderName: "", text:""))
    }
}
