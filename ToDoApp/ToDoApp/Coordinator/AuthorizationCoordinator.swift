//
//  AuthorizationCoordinator.swift
//  ToDoApp
//
//  Created by surexnx on 02.09.2024.
//

import UIKit

protocol ChangeCoordinator: AnyObject {
    func closeCoordinator()
}

final class AuthorizationCoordinator: Coordinator {
    
    weak var delegate: ChangeCoordinator?
    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController, delegate: ChangeCoordinator) {
        self.navigationController = navigationController
        self.delegate = delegate
        navigationController.pushViewController(UIViewController(), animated: false)
    }

    func start() {
        let controller = AuthorizationBuilder(output: self).build()
        navigationController?.setViewControllers([controller], animated: false)
    }

    private func showAuthorizationBuilder() {
        let controller = AuthorizationBuilder(output: self).build()
        navigationController?.pushViewController(controller, animated: false)
    }
    
    private func stop() {
        delegate?.closeCoordinator()
    }
}

// MARK: - AuthorizationOutput

extension AuthorizationCoordinator: AuthorizationOutput {

    func moduleLoad(input: AuthorizationInput) {
    }
    
    func processedUserAuthorizated() {
        stop()
    }
    
    func processedShowAlert(_ id: String) {
        guard let controller = navigationController?.topViewController else { return }
        CustomAlertController.showAlertWithOk(on: controller, title: "Создан новый пользвоатель", message: "Id: " + id)
    }
}
