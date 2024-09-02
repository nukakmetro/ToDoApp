//
//  TabBarController.swift
//  ToDoApp
//
//  Created by surexnx on 30.08.2024.
//

import UIKit

final class TabBarController: UITabBarController {

    private let taskCoordinator: Coordinator

    init() {
        let coordinatorFactory = CoordinatorFactory()
        taskCoordinator = coordinatorFactory.buildTaskCoordinator(UINavigationController(rootViewController: UIViewController()))
        taskCoordinator.start()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let taskNavigaionController = taskCoordinator.navigationController

        guard
            let taskNavigaionController = taskNavigaionController
        else { return }

        taskNavigaionController.tabBarItem.image = UIImage(systemName: "house")
        let controller = UIViewController()
        controller.tabBarItem.image = UIImage(systemName: "person")
        viewControllers = [
            taskNavigaionController,
            controller
        ]
    }
}

