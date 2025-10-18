//
//  AppSession.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 11/08/25.
//

import Firebase
import FirebaseAuth
import Foundation
@preconcurrency import FirebaseFirestore

struct UserProfile:Codable {
    @DocumentID var uid: String?
    let role: String
    let displayName: String?
    let email: String?
}

@MainActor @Observable class AppSession {

    // Auth & Profile
    var authUser: User?
    var profile: UserProfile?
    var isAuthenticated: Bool { authUser != nil }

    //UI Flag
    var isLoading: Bool = true

    private var authHandle: AuthStateDidChangeListenerHandle?

    func start(){
        // Begin listening for auth changes
        authHandle = Auth.auth().addStateDidChangeListener {
            [weak self] _, user in
            guard let self else { return }

            Task {
                self.authUser = user
                if let uid = user?.uid {
                    await self.loadProfile(uid: uid)
                } else {
                    self.profile = nil
                }
                self.isLoading = false
            }
        }
    }

    func stop() {

        if let handel = authHandle {
            Auth.auth().removeStateDidChangeListener(handel)
            authHandle = nil
        }
    }

    func signOut() async {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out error: \(error.localizedDescription)")
            // Handel error
        }
        authUser = nil
        profile = nil
    }

    // Firestore : users/{uid}

    func loadProfile(uid: String) async {

        do {
            let snapshot = try await Firestore.firestore().collection("users")
                .document(uid).getDocument()
            
            if snapshot.exists {
                profile = try snapshot.data(as: UserProfile.self)

            }else {
               try await self.createProfile(uid: uid)
            }
            
        } catch {
            print("Load Profile: \(error.localizedDescription)")
            // manage error
        }

    }
    
    func createProfile(uid: String) async throws {

        try await Firestore.firestore().collection("users").document(uid).setData(
            [
                "email": self.authUser?.email ?? "",
                "displayName": "",
                "role":"viewer"
                
            ], merge: true)
        
    }

}
