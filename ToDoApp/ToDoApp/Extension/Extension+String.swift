//
//  Extension + String.swift
//  ToDoApp
//
//  Created by surexnx on 02.09.2024.
//

import Foundation

extension String {
    var containsOnlyDigits: Bool {
        return self.allSatisfy { $0.isNumber }
    }
}
