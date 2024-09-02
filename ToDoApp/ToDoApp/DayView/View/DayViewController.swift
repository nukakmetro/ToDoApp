//
//  DayViewController.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//

import Foundation
import UIKit
import Combine

final class DayViewController: CustomViewController<DateDisplay, TaskDisplay> {

    // MARK: Internal properties

    // MARK: Private properties

    private let viewModel: any DayViewModeling

    private var dateDisplay: DateDisplay
    private var cells: [TaskDisplay] = []
    private var cancellables: Set<AnyCancellable> = []

    private var dataSource: UITableViewDiffableDataSource<Int, TaskDisplay>?

    private lazy var dateLabel = UILabel()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    private lazy var tableView = UITableView()

    init(viewModel: any DayViewModeling) {
        self.viewModel = viewModel
        self.dateDisplay = DateDisplay(date: Date(), dateString: "", update: false)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        setupTableView()
        setupIndicator()
        setupConstraints()
        createDataSource()
        configureIO()
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
            configureCells(with: dispayData)
        case .error:
            break
        }
    }

    override func configure(_ data: DateDisplay) {
        if data.update == true {
            self.dateDisplay = data
            dateLabel.text = data.dateString
            activityIndicator.startAnimating()
            viewModel.trigger(.onLoad(data.date))
        }
    }

    private func setupIndicator() {
        activityIndicator.hidesWhenStopped = true
    }

    private func setupTableView() {
        tableView.register(DayViewCell.self, forCellReuseIdentifier: DayViewCell.reuseIdentifier)
        tableView.backgroundColor = .white
        tableView.delegate = self
    }

    private func createDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, TaskDisplay>(tableView: tableView)  { [weak self] _, indexPath, item in
            guard let self = self else { return UITableViewCell() }

            let cell = self.tableView.dequeueReusableCell(withIdentifier: DayViewCell.reuseIdentifier, for: indexPath) as? DayViewCell
            cell?.configure(task: item)

            cell?.processedTappedCompletedButton = { [weak self] id, value in
                guard let self = self else { return }
                viewModel.trigger(.processedTappedCompleted(id, indexPath.row ,value))
            }

            return cell ?? UITableViewCell()
        }
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, TaskDisplay>()
        snapshot.appendSections([0])
        snapshot.appendItems(cells)

        let contentOffset = tableView.contentOffset

        UIView.performWithoutAnimation {
            dataSource?.apply(snapshot, animatingDifferences: false)
        }
        tableView.setContentOffset(contentOffset, animated: false)
    }

    private func configureCells(with data: [TaskDisplay]) {
        cells = data
        self.activityIndicator.stopAnimating()
        reloadData()
    }

    private func setupLabel() {
        dateLabel.textColor = .black
        dateLabel.font = .systemFont(ofSize: 17)
    }

    private func setupConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension DayViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let processedTappedCell = processedTappedCell else { return }
        processedTappedCell(cells[indexPath.row])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            viewModel.trigger(.processedTappedDelete(cells[indexPath.row].id, indexPath.row))
            completionHandler(true)
        }
        let action = UIContextualAction(style: .destructive, title: "Отменить") { _,_,completionHandler in
            completionHandler(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, action])
        return configuration
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = cells[indexPath.row]
        let height: CGFloat = item.body?.count ?? 0 > 100 ? 50: 100
        return height

    }
}
