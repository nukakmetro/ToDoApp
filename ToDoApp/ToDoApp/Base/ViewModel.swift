//
//  ViewModel.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//

import Combine

protocol ViewModel: ObservableObject where ObjectWillChangePublisher.Output == Void {
    associatedtype State
    associatedtype Intent

    var state: State { get }
    func trigger(_ intent: Intent)
}

protocol UIKitViewModel: ViewModel {
    var stateDidChange: ObservableObjectPublisher { get }
}
