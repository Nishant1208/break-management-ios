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
        guard let userId = authRepository.currentUserId() else {
            showLogin()
            return
        }

        showLoadingScreen()

        Task {
            do {
                let hasSubmitted = try await dataRepository.hasSubmittedQuestionnaire(userId: userId)
                await MainActor.run {
                    if hasSubmitted {
                        showBreakScreen()
                    } else {
                        showQuestionnaire()
                    }
                }
            } catch {
                await MainActor.run {
                    showQuestionnaire()
                }
            }
        }
    }

    // MARK: - Navigation

    private func showLoadingScreen() {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor(red: 0.10, green: 0.10, blue: 0.25, alpha: 1)
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.startAnimating()
        indicator.center = vc.view.center
        indicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        vc.view.addSubview(indicator)
        navigationController.setViewControllers([vc], animated: false)
    }

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
