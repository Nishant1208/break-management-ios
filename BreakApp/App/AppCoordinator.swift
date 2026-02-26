//
//  AppCoordinator.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import UIKit
import FirebaseAuth

final class AppCoordinator {

    // MARK: - Properties

    private let window: UIWindow
    private let navigationController: UINavigationController
    private let authRepository: AuthRepositoryProtocol

    // MARK: - Init

    init(
        window: UIWindow,
        authRepository: AuthRepositoryProtocol
    ) {
        self.window = window
        self.authRepository = authRepository
        self.navigationController = UINavigationController()
    }

    // MARK: - Start

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        determineInitialFlow()
    }

    // MARK: - Flow Logic

    private func determineInitialFlow() {
        if authRepository.currentUserId() == nil {
            showLogin()
        } else {
            showQuestionnaire()
        }
    }

    // MARK: - Navigation

    private func showLogin() {
        let viewModel = LoginViewModel(
            authRepository: authRepository
        )

        let viewController = LoginViewController(
            viewModel: viewModel
        )

        viewModel.onLoginSuccess = { [weak self] in
            self?.showQuestionnaire()
        }

        navigationController.setViewControllers([viewController], animated: false)
    }

    private func showQuestionnaire() {
        // Temporary placeholder until we implement questionnaire screen
        let vc = UIViewController()
        vc.view.backgroundColor = .systemGreen
        vc.title = "Questionnaire"
        navigationController.setViewControllers([vc], animated: true)
    }
}
