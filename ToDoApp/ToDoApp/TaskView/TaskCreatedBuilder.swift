//
//  TaskCreatedBuilder.swift
//  ToDoApp
//
//  Created by surexnx on 02.09.2024.
//

import UIKit

final class TaskCreatedBuilder: Builder {

    private let output: TaskOutput

    init(output: TaskOutput) {
        self.output = output
    }

    func build() -> UIViewController {
        let viewModel = TaskViewModel(output: output)
        let controller = TaskViewController(viewModel: viewModel)
        controller.configure("Создать")
        return controller
    }
}
