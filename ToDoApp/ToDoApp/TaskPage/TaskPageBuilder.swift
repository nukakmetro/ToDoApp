//
//  TaskPageBuilder.swift
//  ToDoApp
//
//  Created by surexnx on 30.08.2024.
//

import UIKit

final class TaskPageBuilder: Builder {

    private let output: TaskPageOutput

    init(output: TaskPageOutput) {
        self.output = output
    }

    func build() -> UIViewController {
        let viewModel = TaskPageViewModel(output: output)
        let controller = TasksPageViewController(viewModel: viewModel)
        
        return controller
    }
}
