//
//  DayDataMapper.swift
//  ToDoApp
//
//  Created by surexnx on 31.08.2024.
//

import Foundation

final class DayDataMapper {

    private let dateTimeHelper: DateTimeHelper

    init(dateTimeHelper: DateTimeHelper = DateTimeHelper()) {
        self.dateTimeHelper = dateTimeHelper
    }

    func displayData(tasks: [TaskModel]) -> [TaskDisplay] {
        mapToTask(tasks: tasks)
    }

    private func mapToTask(tasks: [TaskModel]) -> [TaskDisplay] {
        var result: [TaskDisplay] = []

        tasks.forEach { task in
                result.append(TaskDisplay(id: Int(task.id),
                                          isCompleted: task.isCompleted,
                                          body: task.body,
                                          dateCreatedString: dateMapToTime(task.dateCreated),
                                          dateCreated: task.dateCreated,
                                          taskTimeString: optionalDateMapToTime(task.taskTime),
                                          taskTime: task.taskTime)
                )
        }

        return result
    }

    private func optionalDateMapToTime(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        let calendar = dateTimeHelper.current

        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        return "\(hour):\(minute)"
    }

    private func dateMapToTime(_ date: Date) -> String {
        let calendar = dateTimeHelper.current

        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        return "\(hour):\(minute)"
    }


}
