//
//  LoginView.swift
//  uTravel
//
//  Created by James Flair on 12/23/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    @StateObject var modelView = ProfileViewViewModel()
    
    var body: some View {
        NavigationView{
            VStack {
                HeaderView(title: "uTravel",
                           subtitle: "Let's Roam",
                           angle: 15,
                           background: .purple)
                .padding(.top)
                
                Form{
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color.red)
                    }
                    
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TLButton(
                        title: "Log In",
                        background: .blue
                    ){
                        viewModel.login()
                    }
                    .padding()
                }
                .offset(y:-50)
                
                VStack{
                    Text("New Around Here?")
                    
                    NavigationLink("Create An Account", destination: RegisterView())
                }
                .padding(.bottom)
                Button(action: signInWithGoogle) {
                    HStack {
                        Image(systemName: "g.circle.fill")
                            .foregroundColor(.red)
                        Text("Sign in with Google")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                }
                .padding(.horizontal)
                
                Button(action: signInWithApple) {
                    HStack {
                        Image(systemName: "apple.logo")
                            .foregroundColor(.black)
                        Text("Sign in with Apple")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
    
    func signInWithGoogle() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            modelView.signInWithGoogle(presenting: rootViewController)
        }
    }
    
    func signInWithApple() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            modelView.signInWithApple(presenting: rootViewController)
        }
    }
}




    
struct LoginView_Previews: PreviewProvider {
    static var previews: some View{
        LoginView()
    }
}
