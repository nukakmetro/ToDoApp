//
//  DauViewCell.swift
//  ToDoApp
//
//  Created by surexnx on 29.08.2024.
//

import Foundation
import UIKit

final class DayViewCell: UITableViewCell {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "DayViewCell"

    // MARK: Internal properties

    var processedTappedCompletedButton: ((_ id: Int, _ value: Bool) -> ())?

    // MARK: Private properties
    private var taskId: Int?
    private var isCompleted: Bool?
    private lazy var completedButton = UIButton()
    private lazy var bodyLabel = UILabel()
    private lazy var dateCreated = UILabel()
    private lazy var taskTime = UILabel()

    // MARK: Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupConstraints()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        completedButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(completedButton)

        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bodyLabel)

        dateCreated.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateCreated)

        taskTime.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(taskTime)

        NSLayoutConstraint.activate([
            completedButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            completedButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            completedButton.heightAnchor.constraint(equalToConstant: 20),
            completedButton.widthAnchor.constraint(equalToConstant: 20),

            taskTime.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            taskTime.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            bodyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            dateCreated.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            dateCreated.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

        ])
    }

    private func setupSubviews() {
        setupButton()
        setupLabel()
    }

    private func setupButton() {
        completedButton.layer.cornerRadius = 2
        completedButton.clipsToBounds = true
        completedButton.layer.borderColor = UIColor.black.cgColor
        completedButton.layer.borderWidth = 2.0
        completedButton.tintColor = .systemGreen

        let action = UIAction { [weak self] _ in
            self?.isCompleted?.toggle()
            guard 
                let self = self,
                let processedTappedCompletedButton = processedTappedCompletedButton,
                let isCompleted = isCompleted,
                let taskId = taskId
            else { return }
            setupCompetedBodyColor(isCompleted)
            processedTappedCompletedButton(taskId, isCompleted)
        }

        completedButton.addAction(action, for: .touchUpInside)

    }

    private func setupLabel() {
        bodyLabel.numberOfLines = 0
        bodyLabel.lineBreakMode = .byWordWrapping
        bodyLabel.textColor = .black
        taskTime.textColor = .black
    }

    private func setupCompetedBodyColor(_ isCompleted: Bool) {
        let image = isCompleted ? UIImage(systemName: "checkmark") : nil
        completedButton.setImage(image, for: .normal)
    }

    func configure(task: TaskDisplay) {
        setupCompetedBodyColor(task.isCompleted)
        dateCreated.text = "Create " + task.dateCreatedString
        taskTime.text = task.taskTimeString
        bodyLabel.text = task.body
        taskId = task.id
        isCompleted = task.isCompleted
    }
}
