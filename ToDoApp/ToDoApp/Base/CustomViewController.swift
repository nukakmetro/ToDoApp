//
//  CustomViewController.swift
//  ToDoApp
//
//  Created by surexnx on 01.09.2024.
//

import Foundation
import UIKit

class CustomViewController<T, value>: UIViewController {
    func configure(_ data: T) {}
    var processedTappedCell: ((value) -> ())?
}
