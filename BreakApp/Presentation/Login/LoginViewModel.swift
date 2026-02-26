//
//  LoginViewModel.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import Foundation

final class LoginViewModel {

    // MARK: - Dependencies

    private let authRepository: AuthRepositoryProtocol

    // MARK: - Callbacks

    var onLoginSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?

    // MARK: - Init

    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

    // MARK: - Public Methods

    func login(email: String?, password: String?) {
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            onError?("Email and password cannot be empty.")
            return
        }

        Task {
            await performLogin(email: email, password: password)
        }
    }

    // MARK: - Private

    private func performLogin(email: String, password: String) async {

        await MainActor.run {
            self.onLoadingStateChange?(true)
        }

        do {
            try await authRepository.login(email: email, password: password)

            await MainActor.run {
                self.onLoadingStateChange?(false)
                self.onLoginSuccess?()
            }

        } catch {
            await MainActor.run {
                self.onLoadingStateChange?(false)
                self.onError?(error.localizedDescription)
            }
        }
    }
}
