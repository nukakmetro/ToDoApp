//
//  TaskIntent.swift
//  ToDoApp
//
//  Created by surexnx on 30.08.2024.
//

import Foundation

enum TaskIntent {
    case willLoad
    case onLoad
    case processedChangeTime(_ date: Date)
    case processedTappedIsTimeButton
    case processedTappedButton(_ text: String)
}
