//
//  TaskState.swift
//  ToDoApp
//
//  Created by surexnx on 30.08.2024.
//

enum TaskState {
    case loading
    case content(display: DayDisplay)
    case error
}
