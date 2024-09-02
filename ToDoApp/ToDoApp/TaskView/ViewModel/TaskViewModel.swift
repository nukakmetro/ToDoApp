//
//  TaskViewModel.swift
//  ToDoApp
//
//  Created by surexnx on 30.08.2024.
//

import Combine

protocol TaskViewModeling: UIKitViewModel where State == TaskState, Intent == TaskIntent {}

final class TaskViewModel: TaskViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    private var coreDataManager: CoreDataManager
    private let dataMapper: TaskPageDataMapper
    private var days: [DayDisplay]
    weak private var output: TaskOutput?

    // MARK: Internal properties

    @Published var state: TaskState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

    init(output: TaskOutput, dataMapper: TaskPageDataMapper = TaskPageDataMapper(), coreData: CoreDataManager = CoreDataManager.shared) {
        self.days = []
        self.output = output
        self.dataMapper = dataMapper
        self.coreDataManager = coreData
        self.stateDidChange = ObjectWillChangePublisher()
        self.state = .loading

    }

    // MARK: Internal methods

    func trigger(_ intent: TaskIntent) {
        switch intent {

        case .willLoad:
            output?.moduleLoad(input: self)
        case .onLoad:
            break
        }
    }

    // MARK: Private methods

}

// MARK: - TaskInput

extension TaskViewModel: TaskInput {
    func processedSendTask(_ task: TaskDisplay) {
        
    }
}
