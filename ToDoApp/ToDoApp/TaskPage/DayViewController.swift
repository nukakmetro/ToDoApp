//
//  DayViewController.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//

import Foundation
import UIKit

final class DayViewController: UIViewController {
    var color: UIColor
    private lazy var textDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()

    init(_ value: UIColor) {
        color = value
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textDate)
        NSLayoutConstraint.activate([
            textDate.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            textDate.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        view.backgroundColor = color
        setupUI()
    }

    func configure(with data: DayDisplay) {
        textDate.text = data.dateString
    }

    private func setupUI() {
    }

    private func updateUI() {
      
    }
}
