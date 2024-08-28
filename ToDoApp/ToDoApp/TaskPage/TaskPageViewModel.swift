//
//  TaskPageViewModel.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//

import Foundation
import Combine

class YTT {
    var yesterdayDay: Day?
    var today: Day?
    var tomorrow: Day?
}

protocol TaskPageViewModeling: UIKitViewModel where State == TaskPageState, Intent == TaskPageIntent {}

final class TaskPageViewModel: TaskPageViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    private var coreDataManager = CoreDataManager.shared
    private let dataMapper: TaskPageDataMapper
    private var days: [DayDisplay]
    // MARK: Internal properties

    @Published var state: TaskPageState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

    init() {
        self.days = []
        self.dataMapper = TaskPageDataMapper()
        self.stateDidChange = ObjectWillChangePublisher()
        self.state = .loading

    }

    // MARK: Internal methods

    func trigger(_ intent: TaskPageIntent) {
        switch intent {

        case .onLoad:
            state = .loading

            let displayData = coreDataManager.fetchTaskForYTT(for: Date())
            days = dataMapper.displayData(data: displayData)
            state = .content(display: days)

        case .processedScrolledBack(let index, let backIndex):
            scrolledBack(index, backIndex)
        case .processedScrolledForward(let index, let nextIndex):
            scrolledForward(index, nextIndex)
        }
    }

    // MARK: Private methods

    private func scrolledForward(_ index: Int, _ nextIndex: Int) {
        state = .loading
        let forwardDay = coreDataManager.fetchAfterDay(for: days[index].date)
        days[nextIndex] = dataMapper.mapTo(value: forwardDay)
        state = .content(display: days)
    }

    private func scrolledBack(_ index: Int, _ backIndex: Int) {
        state = .loading
        let backDay = coreDataManager.fetchBeforeDay(for: days[index].date)

        days[backIndex] = dataMapper.mapTo(value: backDay)
        state = .content(display: days)
    }
}
