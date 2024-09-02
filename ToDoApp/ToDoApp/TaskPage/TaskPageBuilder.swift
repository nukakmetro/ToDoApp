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
        let firstVC = DayViewBuilder().build()
        let secondVC = DayViewBuilder().build()
        let threeVC = DayViewBuilder().build()
        firstVC.view.tag = 0
        secondVC.view.tag = 1
        threeVC.view.tag = 2
        let controller = TasksPageViewController(viewModel: viewModel, controllers: [firstVC, secondVC, threeVC])

        return controller
    }
}
