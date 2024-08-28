//
//  TaskPageDataMapper.swift
//  ToDoApp
//
//  Created by surexnx on 28.08.2024.
//

import Foundation

struct DayDisplay {
    let dateString: String
    let date: Date
    var tasks: [TaskDisplay]
}

struct TaskDisplay {
    var id: Int
    var isCompleted: Bool
    var body: String?
    var dateCreated: Date
    var taskTime: Date?
}

final class TaskPageDataMapper {

    func displayData(data: [DayEntity]?) -> [DayDisplay] {
        var result: [DayDisplay] = []
        
         data?.forEach({ day in
             result.append(mapTo(value: day))
        })
        return result
    }

    func mapTo(value: DayEntity) -> DayDisplay {
        let result = DayDisplay(dateString: dateMapToString(date: value.date),
                                date: value.date,
                                tasks: mapToTask(tasks: value.tasks)
        )
        return result
    }

    func mapToTask(tasks: [TaskModel]) -> [TaskDisplay] {
        var result: [TaskDisplay] = []

        tasks.forEach { task in
            result.append(TaskDisplay(id: Int(task.id),
                                      isCompleted: task.isCompleted,
                                      body: task.body,
                                      dateCreated: task.dateCreated,
                                      taskTime: task.taskTime )
            )
        }
        return result
    }

    private func dateMapToString(date: Date) -> String {
        let calendar = Calendar.current

        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return "\(day) \(month)"
    }
}
