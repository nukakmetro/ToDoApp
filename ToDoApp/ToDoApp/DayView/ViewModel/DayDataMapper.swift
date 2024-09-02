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
        let sortedTasks = result.sorted { (task1, task2) -> Bool in
            if task1.taskTime == nil && task2.taskTime != nil {
                return true
            } else if task1.taskTime != nil && task2.taskTime == nil {
                return false
            } else if let time1 = task1.taskTime, let time2 = task2.taskTime {
                return time1 < time2
            } else {
                if let body1 = task1.body, let body2 = task2.body {
                    return body1 < body2
                } else {
                    return task1.body != nil
                }
            }
        }
        return sortedTasks
    }

    private func optionalDateMapToTime(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        let calendar = dateTimeHelper.current

        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        if minute < 10 {
            return "\(hour):0\(minute)"
        }
        return "\(hour):\(minute)"
    }

    private func dateMapToTime(_ date: Date) -> String {
        let calendar = dateTimeHelper.current

        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        if minute < 10 {
            return "\(hour):0\(minute)"
        }
        return "\(hour):\(minute)"
    }


}
