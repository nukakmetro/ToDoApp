//
//  DayIO.swift
//  ToDoApp
//
//  Created by surexnx on 31.08.2024.
//

import Foundation

protocol DayInput: AnyObject {
    func processedSendTask(_ task: TaskDisplay)
}

protocol DayOutput: AnyObject {
    func moduleLoad(input: TaskPageInput)
    func processedTappedCell(task: TaskDisplay)
    func processedTappedCreate(task: TaskDisplay)
}
