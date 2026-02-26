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
    private let dataRepository: DataRepositoryProtocol

    // MARK: - Init

    init(
        window: UIWindow,
        authRepository: AuthRepositoryProtocol,
        dataRepository: DataRepositoryProtocol
    ) {
        self.window = window
        self.authRepository = authRepository
        self.dataRepository = dataRepository
        self.navigationController = UINavigationController()
    }

    // MARK: - Start

    func start() {
        navigationController.setNavigationBarHidden(true, animated: false)
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
        let viewModel = LoginViewModel(authRepository: authRepository)

        let viewController = LoginViewController(viewModel: viewModel)

        viewModel.onLoginSuccess = { [weak self] in
            self?.showQuestionnaire()
        }

        navigationController.setViewControllers([viewController], animated: false)
    }

    private func showQuestionnaire() {
        guard let userId = authRepository.currentUserId() else {
            showLogin()
            return
        }

        let viewModel = QuestionnaireViewModel(
            dataRepository: dataRepository,
            userId: userId
        )

        let viewController = QuestionnaireViewController(viewModel: viewModel)

        viewModel.onBack = { [weak self] in
            self?.showLogin()
        }

        viewModel.onSubmitSuccess = { [weak self] in
            self?.showBreakScreen()
        }

        navigationController.setViewControllers([viewController], animated: true)
    }

    private func showBreakScreen() {
        guard let userId = authRepository.currentUserId() else {
            showLogin()
            return
        }

        let viewModel = BreakViewModel(
            dataRepository: dataRepository,
            userId: userId
        )

        let viewController = BreakViewController(viewModel: viewModel)

        navigationController.setViewControllers([viewController], animated: true)
    }
}
