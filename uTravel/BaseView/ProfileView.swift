//
//  Profile View.swift
//  uTravel
//
//  Created by James Flair on 12/23/24.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    

    var body: some View {
        NavigationView{
            if let user = viewModel.user{
                profile(user: user)
            }
//            } else {
//                ProgressView("Loading Profile...")
//                    .progressViewStyle(CircularProgressViewStyle())
    

        }
        .navigationTitle("Profile")
        .onAppear {
            viewModel.fetchUser()
    }
}
    @ViewBuilder func profile(user: User) -> some View {
        //Avatar
        Image(systemName: "person.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(Color.blue)
            .frame(width: 125, height: 125)
            .padding()
        
        //Info: Name, Email, Member since
        VStack(alignment: .leading) {
            HStack{
                Text("Name")
                    .bold()
                Text(user.name)
            }
            .padding()
            HStack{
                Text("Email")
                    .bold()
                Text(user.email)
            }
            .padding()
            HStack{
                Text("Member Since")
                Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
            }
            .padding()
        }
        .padding()
        
        // Sign Out
        Button("Log Out"){
            viewModel.logOut()
        }
        .tint(.red)
        .padding()
        
        Spacer()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
 
