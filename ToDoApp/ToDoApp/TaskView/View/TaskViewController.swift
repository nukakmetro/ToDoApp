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
    private lazy var textView = UITextView()
    private lazy var timePicker = UIDatePicker()
    private lazy var button = UIButton()
    private lazy var isTimeButton = UIButton()

    init(viewModel: any TaskViewModeling) {
        self.viewModel = viewModel
        viewModel.trigger(.willLoad)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Color")
        setupView()
        configureIO()
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
            configurationView(dispayData)

        case .error:
            dismiss(animated: true)
        }
    }

    private func setupView() {
        setupTimePicker()
        setupButton()
        setupIsTimeButton()
        setupTextField()
        setupConstraint()
    }

    private func configurationView(_ dispayData: TaskEntity) {
        textView.text = dispayData.body
        changeIsTimeButton(dispayData.isTime)
        timePicker.date = dispayData.taskTime
    }

    private func setupTimePicker() {
        timePicker.datePickerMode = .dateAndTime
        timePicker.preferredDatePickerStyle = .compact
        timePicker.tintColor = .black
        timePicker.locale = .autoupdatingCurrent
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
    }

    private func setupTextField() {
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isEditable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autocapitalizationType = .none
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1.0

        textView
    }

    private func setupIsTimeButton() {
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            viewModel.trigger(.processedTappedIsTimeButton)
        }
        isTimeButton.addAction(action, for: .touchUpInside)
        isTimeButton.translatesAutoresizingMaskIntoConstraints = false
        isTimeButton.layer.cornerRadius = 2
        isTimeButton.clipsToBounds = true
        isTimeButton.layer.borderColor = UIColor.black.cgColor
        isTimeButton.layer.borderWidth = 2.0
        isTimeButton.tintColor = .systemGreen
    }

    private func setupButton() {
        button.configuration = .filled()
        button.translatesAutoresizingMaskIntoConstraints = false
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            if textView.text.count > 0 {
                viewModel.trigger(.processedTappedButton(textView.text))
            }
        }
        button.addAction(action, for: .touchUpInside)
    }

    private func setupConstraint() {
        view.addSubview(timePicker)
        view.addSubview(button)
        view.addSubview(isTimeButton)
        view.addSubview(textView)

        NSLayoutConstraint.activate([
            isTimeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            isTimeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            isTimeButton.heightAnchor.constraint(equalToConstant: 20),
            isTimeButton.widthAnchor.constraint(equalToConstant: 20),

            timePicker.leadingAnchor.constraint(equalTo: isTimeButton.trailingAnchor, constant: 10),
            timePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            timePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            textView.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 40),
            textView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            textView.heightAnchor.constraint(equalToConstant: 100),
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func changeIsTimeButton(_ isTime: Bool) {
        let image = isTime ? UIImage(systemName: "checkmark") : nil
        isTimeButton.setImage(image, for: .normal)
        timePicker.isUserInteractionEnabled = isTime
    }

    @objc private func timeChanged(_ sender: UIDatePicker) {
        viewModel.trigger(.processedChangeTime(sender.date))
    }

    func configure(_ value: String?) {
        if value == nil {
            button.setTitle("Кнопка", for: .normal)
        } else {
            button.setTitle(value, for: .normal)
        }
    }
}

extension TaskViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        if sheetPresentationController.selectedDetentIdentifier == .large {
            
        } else if sheetPresentationController.selectedDetentIdentifier == .medium {
            
        }

    }
}
