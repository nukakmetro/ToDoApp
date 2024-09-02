//
//  AuthorizationBuilder.swift
//  ToDoApp
//
//  Created by surexnx on 02.09.2024.
//

import UIKit

final class AuthorizationBuilder: Builder {

    private let output: AuthorizationOutput

    init(output: AuthorizationOutput) {
        self.output = output
    }

    func build() -> UIViewController {
        
        let viewModel = AuthorizationViewModel(output: output)
        let controller = AuthorizationViewController(viewModel: viewModel)

        return controller
    }
}
