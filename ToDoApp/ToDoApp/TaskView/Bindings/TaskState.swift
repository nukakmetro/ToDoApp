//
//  TaskState.swift
//  ToDoApp
//
//  Created by surexnx on 30.08.2024.
//

enum TaskState {
    case loading
    case content(display: TaskEntity)
    case error
}

enum TaskConf {
    case save
    case change
}
