//
//  AuthManager.swift
//  uTravel
//
//  Created by James Flair on 4/29/25.

import Foundation
import CryptoKit
import AuthenticationServices
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

class AuthManager: NSObject {
    static let shared = AuthManager()
    
    private var currentNonce: String?
    
    typealias AuthCompletion = (Result<User, Error>) -> Void
    private var authCompletion: AuthCompletion?
    
    func signInWithGoogle(presenting viewController: UIViewController, completion: @escaping AuthCompletion) {
        self.authCompletion = completion
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase configuration error"])))
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.authCompletion?(.failure(error))
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self.authCompletion?(.failure(NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get user info from Google"])))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                          accessToken: user.accessToken.tokenString)

            self.signInWithFirebase(credential: credential)
        }
    }
    

    func signInWithApple(presenting viewController: UIViewController, completion: @escaping AuthCompletion) {
        self.authCompletion = completion
        startSignInWithAppleFlow()
    }
    
    private func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func signInWithFirebase(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.authCompletion?(.failure(error))
                return
            }
            
            guard let authResult = authResult else {
                self.authCompletion?(.failure(NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authentication result"])))
                return
            }
            
            let user = User(
                id: authResult.user.uid,
                name: authResult.user.displayName ?? "Unknown",
                email: authResult.user.email ?? "",
                joined: Date().timeIntervalSince1970
            )
            
            self.saveUserToFirestore(user)
            
            self.authCompletion?(.success(user))
        }
    }
    
    private func saveUserToFirestore(_ user: User) {
        let db = Firestore.firestore()
        db.collection("Users").document(user.id).setData([
            "name": user.name,
            "email": user.email,
            "joined": user.joined
        ], merge: true) { error in
            if let error = error {
                print("Error saving user data: \(error)")
            } else {
                print("User data successfully saved")
            }
        }
    }
    
    func getCurrentUser() -> User? {
        guard let authUser = Auth.auth().currentUser else {
            return nil
        }
        
        return User(
            id: authUser.uid,
            name: authUser.displayName ?? "Unknown",
            email: authUser.email ?? "",
            joined: Date().timeIntervalSince1970
        )
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }

        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}


extension AuthManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            authCompletion?(.failure(NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve Apple credentials"])))
            return
        }
        
        guard let nonce = currentNonce else {
            authCompletion?(.failure(NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid state: A login callback was received, but no login request was sent"])))
            return
        }
        
        guard let appleIDToken = appleIDCredential.identityToken else {
            authCompletion?(.failure(NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch identity token"])))
            return
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            authCompletion?(.failure(NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to serialize token string from data"])))
            return
        }
        
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce
        )

        signInWithFirebase(credential: credential)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authCompletion?(.failure(error))
    }
}

extension AuthManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first!
    }
}
