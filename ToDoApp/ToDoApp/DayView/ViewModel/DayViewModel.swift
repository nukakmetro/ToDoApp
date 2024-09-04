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
    private var date: Date

    // MARK: Internal properties

    @Published var state: DayState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

    init(dataMapper: DayDataMapper = DayDataMapper(), coreData: CoreDataManager = CoreDataManager.shared) {
        self.days = []
        self.date = Date()
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
        case .processedTappedDelete(let id, let index):
            processedTappedDelete(id, index)
        }
    }

    // MARK: Private methods

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
        self.date = date
        coreDataManager.asyncFetchTaskForDate(for: date) { [weak self] result in
            guard let self = self else { return }
            switch result {

            case .success(let tasks):
                days = dataMapper.displayData(tasks: tasks)
                DispatchQueue.main.async {
                    self.state = .content(display: self.days)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.state = .error
                }
            }
        }
    }

    private func processedTappedDelete(_ id: Int, _ index: Int) {
        state = .loading
        self.coreDataManager.asyncDeleteTask(id: id) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if result {
                    self.days.remove(at: index)
                    self.state = .content(display: self.days)
                } else {
                    self.getDay(self.date)
                }
            }
        }
    }

}

