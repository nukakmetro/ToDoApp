//
//  Coordinator.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//

import UIKit

final class AppCoordinator {

    // MARK: Internal properties

    private var window: UIWindow?

    // MARK: Initializator

    init(window: UIWindow?) {
        self.window = window
    }

    // MARK: Internal methods

    func start() {
        showAuthorizationModule()
    }

    // MARK: Private methods
    
    private func showAuthorizationModule() {
        let coordinator = CoordinatorFactory().buildAuthorizationCoordinator(UINavigationController(), self)
        coordinator.start()
        window?.rootViewController = coordinator.navigationController
        window?.makeKeyAndVisible()
    }

    private func showTabBar() {
        let tabBarController = TabBarBuilder().build()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

}

// MARK: - ChangeCoordinator

extension AppCoordinator: ChangeCoordinator {
    func closeCoordinator() {
        showTabBar()
    }
}
