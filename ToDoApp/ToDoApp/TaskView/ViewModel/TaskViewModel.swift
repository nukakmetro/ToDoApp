//
//  TaskViewModel.swift
//  ToDoApp
//
//  Created by surexnx on 30.08.2024.
//

import Combine
import Foundation

protocol TaskViewModeling: UIKitViewModel where State == TaskState, Intent == TaskIntent {}

final class TaskViewModel: TaskViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    private var coreDataManager: CoreDataManager
    private let dataMapper: TaskViewDataMapper
    private var task: TaskEntity
    weak private var output: TaskOutput?

    // MARK: Internal properties

    @Published var state: TaskState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

    init(output: TaskOutput, dataMapper: TaskViewDataMapper = TaskViewDataMapper(), coreData: CoreDataManager = CoreDataManager.shared) {
        self.task = TaskEntity(id: 0, taskTime: Date(), isTime: false)
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
        case .processedChangeTime(let time):
            processedChangeTime(time)
        case .processedTappedIsTimeButton:
            processedTappedIsTimeButton()
        case .processedTappedButton(let text):
            task.body = text
            output?.processedTappedButton(task)
            state = .error
        }
    }

    // MARK: Private methods

    private func processedChangeTime(_ value: Date) {
        state = .loading
        task.taskTime = value
        state = .content(display: task)
    }
    private func processedTappedIsTimeButton() {
        state = .loading
        task.isTime.toggle()
        state = .content(display: task)
    }
}

// MARK: - TaskInput

extension TaskViewModel: TaskInput {
    func processedSendTask(_ task: TaskDisplay) {
        state = .loading
        self.task = dataMapper.displayData(task)
        state = .content(display: self.task)
    }
}
