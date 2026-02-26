//
//  SceneDelegate.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        // Dependency Injection
        let authRepository = FirebaseAuthRepository()

        let coordinator = AppCoordinator(
            window: window,
            authRepository: authRepository
        )

        self.coordinator = coordinator
        coordinator.start()
    }
}
