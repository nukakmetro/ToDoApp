//
//  TaskViewDataMapper.swift
//  ToDoApp
//
//  Created by surexnx on 02.09.2024.
//

import Foundation

final class TaskViewDataMapper {

    func displayData(_ task: TaskDisplay) -> TaskEntity {
        TaskEntity(
            id: task.id,
            body: task.body,
            taskTime: task.taskTime ?? Date(),
            isTime: task.taskTime != nil ? true : false
        )
    }
}
