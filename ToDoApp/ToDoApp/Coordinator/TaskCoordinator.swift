//
//  TaskCoordinator.swift
//  ToDoApp
//
//  Created by surexnx on 30.08.2024.
//

import UIKit

final class TaskCoordinator: Coordinator {

    weak var navigationController: UINavigationController?
    weak var taskPageInput: TaskPageInput?
    weak var taskInput: TaskInput?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.pushViewController(UIViewController(), animated: false)
    }

    func start() {
        let controller = TaskPageBuilder(output: self).build()
        navigationController?.setViewControllers([controller], animated: false)
    }

    private func showTaskPage() {
        let controller = TaskPageBuilder(output: self).build()
        navigationController?.pushViewController(controller, animated: false)
    }

    private func showTaskView() {
        let controller = TaskBuilder(output: self).build()
        navigationController?.modalPresentationStyle = .pageSheet
        navigationController?.present(controller, animated: true)
    }

}

//MARK: - TaskPageOutput

extension TaskCoordinator: TaskPageOutput {
    func processedTappedCell(task: TaskDisplay) {

    }
    
    func processedTappedCreate(task: TaskDisplay) {
        taskInput?.processedSendTask(task)
        showTaskView()
    }
    
    func moduleLoad(input: TaskPageInput) {
        taskPageInput = input
    }
}

//MARK: - TaskOutput

extension TaskCoordinator: TaskOutput {
    func moduleLoad(input: TaskInput) {
        taskInput = input
    }
}
