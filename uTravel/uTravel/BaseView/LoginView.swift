//
//  LoginView.swift
//  uTravel
//
//  Created by James Flair on 12/23/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    
    var body: some View {
        NavigationView{
            VStack {
                //Header
                HeaderView(title: "uTravel",
                           subtitle: "Let's Roam",
                           angle: 15,
                           background: .purple)
           
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
                
                //Create Account
                VStack{
                    Text("New Around Here?")
                   
                    NavigationLink("Create An Account", destination: RegisterView())
                    }
                }
                .padding(.bottom, 50)
                
                Spacer()
            }
        }
    }

    
struct LoginView_Previews: PreviewProvider {
    static var previews: some View{
        LoginView()
    }
}
