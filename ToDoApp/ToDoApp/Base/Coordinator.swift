//
//  Coordinator.swift
//  ToDoApp
//
//  Created by surexnx on 30.08.2024.
//

import UIKit

protocol Coordinator: AnyObject {

    var navigationController: UINavigationController? { get set }
    func start()
}
