//
//  TaskPageDataMapper.swift
//  ToDoApp
//
//  Created by surexnx on 28.08.2024.
//

import Foundation
import DGCharts

struct DayDisplay {
    let dateString: String
    let date: Date
    var tasks: [TaskDisplay]
}

struct TaskDisplay: Hashable {
    var id: Int
    var isCompleted: Bool
    var body: String?
    var dateCreatedString: String
    var dateCreated: Date
    var taskTimeString: String?
    var taskTime: Date?
}

struct DateDisplay: Hashable {
    var date: Date
    var dateString: String
}

final class TaskPageDataMapper {

    private let dateTimeHelper: DateTimeHelper

    init(dateTimeHelper: DateTimeHelper = DateTimeHelper()) {
        self.dateTimeHelper = dateTimeHelper
    }

    private func dateMapToString(date: Date) -> String {
        var calendar = dateTimeHelper.current

        if calendar.isDateInToday(date) {
            return "Сегодня"
        } else if calendar.isDateInYesterday(date) {
            return "Вчера"
        } else if calendar.isDateInTomorrow(date) {
            return "Завтра"
        }

        let day = calendar.component(.day, from: date)
        let monthInt = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)

        var result = "\(day)"
        if let month = Month(rawValue: monthInt) {
            result.append(" \(month.monthName())")
        } else {
            result.append(" \(monthInt)")
        }
        let nowYear = calendar.component(.year, from: Date())
        if nowYear != year {
            result.append(" \(year)")
        }
        return result
    }
    
    func displayData() -> [DateDisplay] {
        let today = dateTimeHelper.getStartNowDate()
        let yesterday = dateTimeHelper.yesterday(for: today)
        let tomorrow =  dateTimeHelper.tomorrow(for: today)
        return [
            mapToDateDisplay(for: yesterday),
            mapToDateDisplay(for: today),
            mapToDateDisplay(for: tomorrow)
        ]
    }

    func displayDateTomorrow(for date: Date) -> DateDisplay {
        let date = dateTimeHelper.tomorrow(for: date)
        return mapToDateDisplay(for: date)
    }

    func displayDateYesterday(for date: Date) -> DateDisplay {
        let date = dateTimeHelper.yesterday(for: date)
        return mapToDateDisplay(for: date)
    }

    private func mapToDateDisplay(for date: Date) -> DateDisplay {
        DateDisplay(date: date, dateString: dateMapToString(date: date))
    }
}
