//
//  CustomAlertController.swift
//  ToDoApp
//
//  Created by surexnx on 02.09.2024.
//

import Foundation
import UIKit

final class CustomAlertController {

    static func showAlertWithOk(on viewController: UIViewController, title: String, message: String, okHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Да", style: .default) { _ in
            okHandler?()
        }
        alert.addAction(okAction)

        viewController.present(alert, animated: true, completion: nil)
    }
}
