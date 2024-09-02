//
//  TaskViewBuilder.swift
//  ToDoApp
//
//  Created by surexnx on 30.08.2024.
//

import UIKit

final class TaskBuilder: Builder {

    private let output: TaskOutput

    init(output: TaskOutput) {
        self.output = output
    }

    func build() -> UIViewController {
        let viewModel = TaskViewModel(output: output)
        let controller = TaskViewController(viewModel: viewModel)

        return controller
    }
}
