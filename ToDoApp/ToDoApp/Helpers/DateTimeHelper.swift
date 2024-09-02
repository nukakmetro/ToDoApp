//
//  DateTimeHelper.swift
//  ToDoApp
//
//  Created by surexnx on 30.08.2024.
//

import Foundation

final class DateTimeHelper {

    var current = Calendar.current

    init() {
        current.timeZone = .autoupdatingCurrent
    }

    func addingTimeInterval(_ date: Date) -> Date {
        date.addingTimeInterval(3 * 60 * 60)
    }

    func startOfDay(for date: Date) -> Date {
       current.startOfDay(for: date)
    }

    func getStartNowDate() -> Date {
        current.startOfDay(for: Date())
    }

    func nowDate() -> Date {
        Date()
    }

    func yesterday(for date: Date) -> Date {
        current.date(byAdding: .day, value: -1, to: date) ?? Date(timeIntervalSinceNow: -86400)
    }

    func tomorrow(for date: Date) -> Date {
        current.date(byAdding: .day, value: 1, to: date) ?? Date(timeIntervalSinceNow: 86400)
    }
}
