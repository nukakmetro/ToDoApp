//
//  TaskPageIntent.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//

import Foundation

enum TaskPageIntent {
    case willLoad
    case onLoad
    case processedScrolledBack(_ index: Int, _ backIndex: Int)
    case processedScrolledForward(_ index: Int, _ nextIndex: Int)
    case processedTappedCompletedButton(_ id: Int, _ value: Bool, _ tag: Int)
    case processedTappedAddButton
    case processedTappedCell(_ tag: Int)
}
