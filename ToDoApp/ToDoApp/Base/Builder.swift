//
//  Builder.swift
//  ToDoApp
//
//  Created by surexnx on 30.08.2024.
//

protocol Builder {
    associatedtype T
    func build() -> T
}
