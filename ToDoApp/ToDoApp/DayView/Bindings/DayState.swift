//
//  DayState.swift
//  ToDoApp
//
//  Created by surexnx on 31.08.2024.
//

import Foundation

enum DayState {
    case loading
    case content(display: [TaskDisplay])
    case error
}
