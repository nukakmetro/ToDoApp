//
//  AuthorizationViewModel.swift
//  ToDoApp
//
//  Created by surexnx on 01.09.2024.
//

import Combine

protocol AuthorizationViewModeling: UIKitViewModel where State == AuthorizationState, Intent == AuthorizationIntent {}

final class AuthorizationViewModel: AuthorizationViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    private let userService: UserService
    private var output: AuthorizationOutput?

    // MARK: Internal properties

    @Published var state: AuthorizationState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

    init(output: AuthorizationOutput, userServise: UserService = UserService(coreDataManager: CoreDataManager.shared)) {
        self.output = output
        self.userService = userServise
        self.stateDidChange = ObjectWillChangePublisher()
        self.state = .loading
    }

    // MARK: Internal methods

    func trigger(_ intent: AuthorizationIntent) {
        switch intent {
        case .onLoad:
            break
        case .processedTappedEntry(let value):
            processedTappedEntry(value)
        case .processedCreateUser:
            let id = userService.createUser()
            output?.processedShowAlert(String(id))
        }
    }

    // MARK: Private methods

    private func processedTappedEntry(_ value: String) {
        state = .loading
        let id = value.containsOnlyDigits ? Int(value): nil
        if let id = id {
            authUser(id: id)
        } else {
            state = .error
        }
    }

    private func authUser(id: Int) {
        state = .loading
        userService.authorizate(id: id) { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                output?.processedUserAuthorizated()
            } else {
                state = .error
            }
        }
    }
}

// MARK: - AuthorizationInput

extension AuthorizationViewModel: AuthorizationInput {

    func processedAlertTappedOk() {
        output?.processedUserAuthorizated()
    }
}
