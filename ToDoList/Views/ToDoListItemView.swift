//
//  ToDoListItemView.swift
//  uTravel
//
//  Created by James Flair on 12/23/24.
//

import SwiftUI
import Foundation
 
struct ToDoListItemView: View {
    @StateObject var viewModel = ToDoListItemViewViewModel()
    let item: ToDoListItem
    
    var body: some View {
        HStack {
                VStack{
                    Text(item.title)
                        .font(.callout)
                        .lineLimit(1)
                        .padding(.vertical, 2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(Date(timeIntervalSince1970: item.dueDate).formatted(date: .abbreviated, time: .shortened))")
                        .font(.footnote)
                        .foregroundColor(Color(.secondaryLabel))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                
                Spacer()
            
            Button {
                viewModel.toggleIsDone(item: item)
        
            } label: {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(Color.blue)
            }
            
        }
    }
}

struct ToDoListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListItemView(item: .init(id: "123",
                                     title:"Get Milk",
                                     dueDate:Date().timeIntervalSince1970,
                                     createdDate:Date().timeIntervalSince1970,
                                     isDone: true
                                    ))
    }
}
