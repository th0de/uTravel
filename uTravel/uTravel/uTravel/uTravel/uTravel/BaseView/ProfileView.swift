//
//  Profile View.swift
//  uTravel
//
//  Created by James Flair on 12/23/24.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseAuthCombineSwift
import FirebaseFirestore

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    @State var apiKey: String = UserDefaults.standard.string(forKey: "openai_api_key") ?? ""

    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    profile(user: user)
                } else {
                    ProgressView("Loading Profile...")
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                viewModel.fetchUser()
            }
        }
    }

    @ViewBuilder func profile(user: User) -> some View {
        ScrollView {
            VStack {
                // Avatar
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.blue)
                    .frame(width: 125, height: 125)
                    .padding()

                // Info: Name, Email, Member Since
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Name")
                            .bold()
                        Text(user.name)
                    }
                    HStack {
                        Text("Email")
                            .bold()
                        Text(user.email)
                    }
                    HStack {
                        Text("Member Since")
                        Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
                    }
                }
                .padding()

                // API Key Input
                List {
                    Section("OpenAI API Key") {
                        TextField("Enter key", text: $apiKey)
                            .onChange(of: apiKey) { newValue in
                                UserDefaults.standard.set(newValue, forKey: "openai_api_key")
                            }
                    }
                }
                .frame(height: 100)

                // Sign Out Button
                Button("Log Out") {
                    viewModel.logOut()
                }
                .tint(.red)
                .padding()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
