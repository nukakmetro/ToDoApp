//
//  DayTasks.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//

import Foundation

struct Task {
    let title: String
    let isCompleted: Bool
}

struct DayTasks {
    let date: Date
    var tasks: [Task]
}
