//
//  TaskPageViewModel.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//

import Foundation
import Combine

protocol TaskPageViewModeling: UIKitViewModel where State == TaskPageState, Intent == TaskPageIntent {}

final class TaskPageViewModel: TaskPageViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    private var coreDataManager: CoreDataManager
    private let dataMapper: TaskPageDataMapper
    private var days: [DateDisplay]
    weak private var output: TaskPageOutput?

    // MARK: Internal properties

    @Published var state: TaskPageState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

    init(output: TaskPageOutput, dataMapper: TaskPageDataMapper = TaskPageDataMapper(), coreData: CoreDataManager = CoreDataManager.shared) {
        self.days = []
        self.output = output
        self.dataMapper = dataMapper
        self.coreDataManager = coreData
        self.stateDidChange = ObjectWillChangePublisher()
        self.state = .loading

    }

    // MARK: Internal methods

    func trigger(_ intent: TaskPageIntent) {
        switch intent {
        case .willLoad:
            output?.moduleLoad(input: self)
        case .onLoad:
            state = .loading
            days = dataMapper.displayData()
            state = .content(display: days)
            resetUpdate()
        case .processedScrolledBack(let index, let backIndex):
            scrolledBack(index, backIndex)

        case .processedScrolledForward(let index, let nextIndex):
            scrolledForward(index, nextIndex)
        case .processedTappedCompletedButton(let id, let value, let tag):
            break

        case .processedTappedAddButton:
            output?.processedTappedCreate(task: TaskDisplay(id: 0, isCompleted: false, dateCreatedString: "", dateCreated: Date()))
        case .processedTappedCell(let task):
            output?.processedTappedCell(task: task)
        }
    }

    // MARK: Private methods

    private func scrolledForward(_ index: Int, _ nextIndex: Int) {
        state = .loading
        let dayDisplay = dataMapper.displayDateTomorrow(for: days[index].date)
        days[nextIndex] = dayDisplay
        state = .content(display: days)
        days[nextIndex].update = false
    }

    private func scrolledBack(_ index: Int, _ backIndex: Int) {
        state = .loading
        let dayDisplay = dataMapper.displayDateYesterday(for: days[index].date)
        days[backIndex] = dayDisplay

        state = .content(display: days)
        days[backIndex].update = false

    }

    private func resetUpdate() {
        var i = 0
        while i < days.count {
            days[i].update = false
            i += 1
        }
    }
}

// MARK: - TaskPageInput

extension TaskPageViewModel: TaskPageInput {

    func processedSendTask(_ task: TaskEntity) {
        state = .loading

        if task.id == 0 {
            coreDataManager.createTask(task) { [weak self] _, date in
                self?.update(date: date)
            }
        } else {
            coreDataManager.updateTask(task) { [weak self] _, date in
                self?.update(date: date)
            }
        }
    }

    private func update(date: Date?) {
        guard let date = date else { return }
        var i = 0
        while i < 3 {
            if days[i].date == dataMapper.getStartOfDay(for: date) {
                days[i].update = true
                state = .content(display: days)
                days[i].update = false
                break
            }
            i += 1
        }
    }

}
