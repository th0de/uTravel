//
//  uChatView.swift
//  uTravel
//
//  Created by James Flair on 4/28/25.
//

import SwiftUI
import FirebaseAuth


struct uChatView: View {
    let chatId: String
    let otherUserId: String
    let otherUserName: String
    
    @StateObject var chatViewModel = uChatViewModel(chatId: "")
    @State var text = ""
    
    init(chatId: String, otherUserId: String, otherUserName: String) {
        self.chatId = chatId
        self.otherUserId = otherUserId
        self.otherUserName = otherUserName
        self._chatViewModel = StateObject(wrappedValue: uChatViewModel(chatId: chatId))
    }
    
    var body: some View{
        VStack{
            ScrollViewReader { scrollView in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 8) {
                        ForEach(Array(chatViewModel.messages.enumerated()), id: \.element) { idx, message in
                            MessageView(message: message)
                                .id(idx)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .onChange(of: chatViewModel.messages) { newValue in
                            scrollView.scrollTo(chatViewModel.messages.count - 1, anchor: .bottom )
                    }
                }
            }
        }
            
            HStack {
                TextField("...", text: $text, axis: .vertical)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 18)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.top)
                    .padding()
                ZStack{
                    Button{
                        if text.count > 2 {
                            chatViewModel.sendMessage(text: text) { success in
                                if success {
                                    
                                } else {
                                    print("error sending message ")
                                }
                            }
                            text = ""
                        }
                    } label: {
                        Text("Send")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(uiColor: .systemBlue))
                            .cornerRadius(50)
                            .padding(.horizontal, 7)
                    }
                }
                .padding(.top)
                .shadow(radius: 3)
    
            }       .background(Color(uiColor: .systemGray6))
        }        .navigationTitle("uChat")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top)
    }
}

struct uChatViewPreviews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            uChatView(
                chatId: "preview-chat-id",
                otherUserId: "preview-user-id",
                otherUserName: "John Doe"
            )
        }
    }
}
