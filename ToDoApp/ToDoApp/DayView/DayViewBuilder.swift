//
//  DayViewBuilder.swift
//  ToDoApp
//
//  Created by surexnx on 31.08.2024.
//

import UIKit

final class DayViewBuilder {
    
    private let output: TaskOutput? = nil

    func build() -> DayViewController {
        let viewModel = DayViewModel()
        let controller = DayViewController(viewModel: viewModel)

        return controller
    }
}
