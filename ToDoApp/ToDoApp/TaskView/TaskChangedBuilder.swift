//
//  TaskChangedBuilder.swift
//  ToDoApp
//
//  Created by surexnx on 02.09.2024.
//

import UIKit

final class TaskChangedBuilder: Builder {

    private let output: TaskOutput

    init(output: TaskOutput) {
        self.output = output
    }

    func build() -> UIViewController {
        let viewModel = TaskViewModel(output: output)
        let controller = TaskViewController(viewModel: viewModel)
        controller.configure("Изменить")
        return controller
    }
}
