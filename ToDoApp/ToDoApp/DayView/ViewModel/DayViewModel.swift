//
//  DayViewModel.swift
//  ToDoApp
//
//  Created by surexnx on 31.08.2024.
//

import Combine
import Foundation

protocol DayViewModeling: UIKitViewModel where State == DayState, Intent == DayIntent {}

final class DayViewModel: DayViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    private var coreDataManager: CoreDataManager
    private let dataMapper: DayDataMapper
    private var days: [TaskDisplay]

    // MARK: Internal properties

    @Published var state: DayState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

    init(dataMapper: DayDataMapper = DayDataMapper(), coreData: CoreDataManager = CoreDataManager.shared) {
        self.days = []
        self.dataMapper = dataMapper
        self.coreDataManager = coreData
        self.stateDidChange = ObjectWillChangePublisher()
        self.state = .loading

    }

    // MARK: Internal methods

    func trigger(_ intent: DayIntent) {
        switch intent {

        case .willLoad:
            break
        case .onLoad(let date):
            getDay(date)
        case .processedTappedCompleted(let id, let index, let isCompleted):
            processedTappedIsCompleted(id, index, isCompleted)
        }
    }

    private func processedTappedIsCompleted(_ id: Int, _ index: Int, _ value: Bool) {
        coreDataManager.toggleCompleted(id) { [weak self] isCompleted in
            guard let self = self else { return }
            if let isCompleted = isCompleted {
                self.days[index].isCompleted = isCompleted

            } else {
                self.days[index].isCompleted = value
            }
            state = .content(display: days)
        }
    }

    private func getDay(_ date: Date) {
        state = .loading
        coreDataManager.fetchTaskForDate(for: date) { [weak self] tasks in
            guard let self = self else { return }
            days = dataMapper.displayData(tasks: tasks)

            state = .content(display: days)
        }
    }

    // MARK: Private methods
//    private func processedTappedIsCompleted(_ id: Int, _ value: Bool, _ tag: Int) {
//        state = .loading
//        if let index = days[tag].tasks.firstIndex(where: { $0.id == id }) {
//            var task = days[tag].tasks[index]
//            task.isCompleted = value
//            days[tag].tasks[index] = task
//
//            coreDataManager.toggleCompleted(id) { [weak self] result in
//                guard
//                    let self = self,
//                    let result = result
//                else  { return }
//
//                task.isCompleted = result
//                self.days[tag].tasks[index] = task
//
//                state = .content(display: days)
//            }
//        }
//    }
}

