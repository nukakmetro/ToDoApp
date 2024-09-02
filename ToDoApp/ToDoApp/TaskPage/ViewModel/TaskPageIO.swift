//
//  TaskPageIO.swift
//  ToDoApp
//
//  Created by surexnx on 30.08.2024.
//

protocol TaskPageInput: AnyObject {
    func processedSendTask(_ task: TaskDisplay)
}

protocol TaskPageOutput: AnyObject {
    func moduleLoad(input: TaskPageInput)
    func processedTappedCell(task: TaskDisplay)
    func processedTappedCreate(task: TaskDisplay)
}
