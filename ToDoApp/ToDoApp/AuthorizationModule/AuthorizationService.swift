//
//  AuthorizationService.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//

import Foundation

final class AuthorizationService {
    
    private let coreDataManager = CoreDataManager.shared

    func authorizate(id: Int) -> Bool {
        if let user = coreDataManager.fetchUser(id: id) {
            coreDataManager.setCurrentUser(user: user)
            return true
        }
        return false
    }
}
