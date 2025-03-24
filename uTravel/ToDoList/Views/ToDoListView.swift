//
//  ToDoListItems.swift
//  uTravel
//
//  Created by James Flair on 12/23/24.
//
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import SwiftUI

struct ToDoListView: View {
    @StateObject var viewModel: ToDoListViewViewModel
    @FirestoreQuery var items: [ToDoListItem]
    
    
    init(userId: String) {
        self._items = FirestoreQuery(
            collectionPath: "Users/\(userId)/todos"
        )
        self._viewModel = StateObject(wrappedValue:ToDoListViewViewModel(userId: userId)
        )
    }
    
    var body: some View {
        NavigationView{
            VStack{
                List(items) { item in
                    ToDoListItemView(item: item)
                        .swipeActions{
                            Button("Delete") {
                                viewModel.delete(id: item.id)
                            }
                            .tint(Color.red)
                        }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("To Do List")
            .toolbar {
                Button {
                    //Action
                    viewModel.showingNewItemView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewItemView(newItemPresented:
                                $viewModel.showingNewItemView)
            }
        }
    }
}
    
    struct ToDoListItemsView_PReviews: PreviewProvider {
        static var previews: some View {
            ToDoListView(userId: "" )
        }
    }

