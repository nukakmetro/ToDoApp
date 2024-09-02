//
//  CoordinatorFactory.swift
//  ToDoApp
//
//  Created by surexnx on 30.08.2024.
//

import UIKit

final class CoordinatorFactory {

    func buildAuthorizationCoordinator(_ navigationController: UINavigationController, _ change: ChangeCoordinator) -> Coordinator {
        return AuthorizationCoordinator(navigationController: navigationController, delegate: change)
    }
    
    func buildTaskCoordinator(_ navigationController: UINavigationController) -> Coordinator {
        return TaskCoordinator(navigationController: navigationController)
    }

    func buildAppCoordinator(_ window: UIWindow?) -> AppCoordinator {
        AppCoordinator(window: window)
    }
}
