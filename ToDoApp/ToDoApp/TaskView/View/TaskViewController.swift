//
//  TaskViewController.swift
//  ToDoApp
//
//  Created by surexnx on 30.08.2024.
//

import UIKit
import Combine

final class TaskViewController: UIViewController {

    private let viewModel: any TaskViewModeling
    private var cancellables: Set<AnyCancellable> = []
    private lazy var body = UILabel()
    private lazy var timePicker = UIDatePicker()
    private lazy var timeLabel = UILabel()

    init(viewModel: any TaskViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Color")
        setupTimePicker()
        setupLabel()
        setupConstraint()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let sheet = self.sheetPresentationController {

            let customDetens: UISheetPresentationController.Detent = .custom(identifier: .large) { context in
                return context.maximumDetentValue * 0.7 }

            sheet.detents = [.medium(), customDetens]
            sheet.prefersGrabberVisible = true
        }
    }

    private func configureIO() {
        viewModel
            .stateDidChange
            .sink { [weak self] _ in
                self?.render()
            }
            .store(in: &cancellables)
    }

    private func render() {
        switch viewModel.state {
        case .loading:
            break
        case .content(let dispayData):
            break
        case .error:
            break
        }
    }

    private func setupTimePicker() {
        timePicker.datePickerMode = .dateAndTime
        timePicker.preferredDatePickerStyle = .compact
        timePicker.tintColor = .black
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)

    }

    private func setupLabel() {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = UIColor.label

    }
    
    private func setupConstraint() {
        view.addSubview(timePicker)
        view.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }

    @objc private func timeChanged(_ sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short // Форматирование времени
        let selectedTime = timeFormatter.string(from: sender.date)
        print("Выбранное время: \(selectedTime)")
    }

    func configureView(_ display: TaskDisplay) {
        timePicker.date = display.taskTime ?? Date()

    }
}

extension TaskViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        if sheetPresentationController.selectedDetentIdentifier == .large {
            
        } else if sheetPresentationController.selectedDetentIdentifier == .medium {
            
        }

    }
}
