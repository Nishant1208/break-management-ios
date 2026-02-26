//
//  AuthRepositoryProtocol.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import Foundation

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws
    func logout() throws
    func currentUserId() -> String?
}
