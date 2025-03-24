 //
//  ChatListView.swift
//  uTravel
//
//  Created by James Flair on 3/4/25.
//

import SwiftUI
import Foundation

struct ChatListView: View {
    @StateObject var viewModel = ChatListViewModel()
    
    var body: some View {
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
                    }
                }
            }
        }
        .navigationTitle("Chats")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    //TODO
                } label: {
                    Image(systemName: "person")
                }
            }
        })
        .onAppear {
            if viewModel.loadingState == .none {
                viewModel.fetchData()
            }
        }
    }
}
    
    
    struct ChatListView_Previews: PreviewProvider{
        static var previews: some View{
            ChatListView()
        }
    }

