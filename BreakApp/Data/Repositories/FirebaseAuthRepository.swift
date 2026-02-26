//
//  FirebaseAuthRepository.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import FirebaseAuth

final class FirebaseAuthRepository: AuthRepositoryProtocol {

    func login(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func logout() throws {
        try Auth.auth().signOut()
    }

    func currentUserId() -> String? {
        Auth.auth().currentUser?.uid
    }
}
