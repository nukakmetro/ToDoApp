//
//  AuthorizationService.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//

import Foundation

final class UserService {

    private let coreDataManager: UserCoreData

    init(coreDataManager: UserCoreData) {
        self.coreDataManager = coreDataManager
    }

    func authorizate(id: Int, completion: @escaping (Bool) -> ()) {
        coreDataManager.fetchUser(id: id) { user in
            if let user = user {
                self.coreDataManager.setCurrentUser(user: user)
                completion(true)
            } else {
                completion(false)
            }
        }
    }


    func createUser() -> Int {
        let user = coreDataManager.createUser()
        return Int(user.id)
    }
}
