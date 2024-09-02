//
//  AuthorizationViewController.swift
//  ToDoApp
//
//  Created by surexnx on 01.09.2024.
//

import Foundation
import UIKit
import Combine

final class AuthorizationViewController: UIViewController {

    // MARK: Internal properties

    // MARK: Private properties

    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: any AuthorizationViewModeling

    private lazy var uiView = UIView()
    private lazy var idTextField = UITextField()
    private lazy var entryButton = UIButton()
    private lazy var createButton = UIButton()

    // MARK: Initialization

    init(viewModel: any AuthorizationViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        configureIO()
        viewModel.trigger(.onLoad)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        uiView.layoutIfNeeded()
        uiView.layer.cornerRadius = uiView.frame.width / 6
        idTextField.layer.cornerRadius = idTextField.frame.height / 6
    }


    // MARK: Private methods

    private func setupView() {
        setupNavigationBar()
        setupTextField()
        setupButton()
        makeConstraint()
    }

    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Вход"
    }

    private func setupTextField() {
        idTextField.translatesAutoresizingMaskIntoConstraints = false
        idTextField.returnKeyType = .next
        idTextField.autocapitalizationType = .none
        idTextField.placeholder = "Введите id"
        idTextField.borderStyle = .roundedRect
        idTextField.layer.borderColor = UIColor.black.cgColor
        idTextField.layer.borderWidth = 1.0
    }
    
    private func setupButton() {
        entryButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false

        entryButton.configuration = .filled()
        createButton.configuration = .plain()
        entryButton.setTitle("Войти", for: .normal)
        createButton.setTitle("Создать", for: .normal)

        let action1 = UIAction { [weak self] _ in

            guard 
                let self = self,
                let text = idTextField.text
            else { return }
            self.viewModel.trigger(.processedTappedEntry(text))
        }
        let action2 = UIAction { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.trigger(.processedCreateUser)
        }

        entryButton.addAction(action1, for: .touchUpInside)
        createButton.addAction(action2, for: .touchUpInside)

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
        case .error:
            break
        case .content:
            break
        }
    }

    private func makeConstraint() {
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = .systemGray6
        uiView.layer.masksToBounds = true

        let stackView = UIStackView(arrangedSubviews: [entryButton, createButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(uiView)
        uiView.addSubview(idTextField)
        uiView.addSubview(stackView)

        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            uiView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            uiView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            uiView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),

            idTextField.topAnchor.constraint(equalTo: uiView.topAnchor, constant: 70),
            idTextField.widthAnchor.constraint(equalTo: uiView.widthAnchor, multiplier: 0.7),
            idTextField.centerXAnchor.constraint(equalTo: uiView.centerXAnchor),


            stackView.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 40),
            stackView.centerXAnchor.constraint(equalTo: uiView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: uiView.widthAnchor, multiplier: 0.7)


        ])

        NSLayoutConstraint.activate([

        ])
    }

}
