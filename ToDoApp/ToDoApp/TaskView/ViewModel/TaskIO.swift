//
//  TaskIO.swift
//  ToDoApp
//
//  Created by surexnx on 30.08.2024.
//

protocol TaskInput: AnyObject {
    func processedSendTask(_ task: TaskDisplay)
}

protocol TaskOutput: AnyObject {
    func moduleLoad(input: TaskInput)

}
