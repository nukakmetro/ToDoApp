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

    private func showTaskCreatedView() {
        let controller = TaskCreatedBuilder(output: self).build()
        navigationController?.modalPresentationStyle = .pageSheet
        navigationController?.present(controller, animated: true)
    }

    private func showTaskChangedView() {
        let controller = TaskChangedBuilder(output: self).build()
        navigationController?.modalPresentationStyle = .pageSheet
        navigationController?.present(controller, animated: true)
    }

    private func popView() {
        navigationController?.popViewController(animated: false)
    }
}

//MARK: - TaskPageOutput

extension TaskCoordinator: TaskPageOutput {
    func processedTappedCell(task: TaskDisplay) {
        showTaskChangedView()
        taskInput?.processedSendTask(task)
    }
    
    func processedTappedCreate(task: TaskDisplay) {
        showTaskCreatedView()
        taskInput?.processedSendTask(task)
    }
    
    func moduleLoad(input: TaskPageInput) {
        taskPageInput = input
    }
}

//MARK: - TaskOutput

extension TaskCoordinator: TaskOutput {
    func processedTappedButton(_ value: TaskEntity) {
        popView()
        taskPageInput?.processedSendTask(value)
    }
    
    func moduleLoad(input: TaskInput) {
        taskInput = input
    }
}
