//
//  TaskPageState.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//

import Foundation

enum TaskPageState {
    case loading
    case content(display: [DayDisplay])
    case error
}
