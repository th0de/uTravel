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
    @State var apiKey1: String = UserDefaults.standard.string(forKey: "tripadvisor_api_key") ?? ""

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
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.blue)
                    .frame(width: 125, height: 125)
                    .padding()

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


                List {
                    Section("OpenAI API Key") {
                        TextField("Enter key", text: $apiKey)
                            .onChange(of: apiKey) { newValue in
                                UserDefaults.standard.set(newValue, forKey: "openai_api_key")
                            }
                    }
                    
                    Section("TripAdvisor API Key") {
                        TextField("Enter key", text: $apiKey1)
                            .onChange(of: apiKey1) { newValue in
                                UserDefaults.standard.set(newValue, forKey: "tripadvisor_api_key")
                            }
                    }
                }
                .frame(height: 200)

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
