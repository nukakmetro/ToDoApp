//
//  ParseService.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//

import Foundation

struct Todo: Decodable {
    let id: Int64
    let todo: String
    let completed: Bool
    let userId: Int64
}

struct TodosResponse: Decodable {
    let todos: [Todo]
    let total: Int
    let skip: Int
    let limit: Int
}

class ParseService {

    func parseTodo() -> TodosResponse {
        Bundle.main.decode(TodosResponse.self, from: "todos.json")
    }
}
