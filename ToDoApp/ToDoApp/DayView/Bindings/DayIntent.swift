//
//  DayIntent.swift
//  ToDoApp
//
//  Created by surexnx on 31.08.2024.
//

import Foundation

enum DayIntent {
    case willLoad
    case onLoad(_ date: Date)
    case processedTappedCompleted(_ id: Int, _ index: Int, _ isCompleted: Bool)
}
