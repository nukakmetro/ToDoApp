//
//  AuthorizationIO.swift
//  ToDoApp
//
//  Created by surexnx on 01.09.2024.
//

protocol AuthorizationInput: AnyObject {
}

protocol AuthorizationOutput: AnyObject {
    func moduleLoad(input: AuthorizationInput)
    func processedUserAuthorizated()
    func processedShowAlert(_ id: String)
}
