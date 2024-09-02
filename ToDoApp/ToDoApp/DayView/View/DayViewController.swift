//
//  DayViewController.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//

import Foundation
import UIKit
import Combine

final class DayViewController: CustomViewController<DateDisplay> {

    // MARK: Internal properties

    var processedTappedCell: ((_ id: Int, _ value: Bool, _ tag: Int) -> ())?
    
    // MARK: Private properties
    private let viewModel: any DayViewModeling

    private var dateDisplay: DateDisplay
    private var taskDisplay: [TaskDisplay] = []
    private var cancellables: Set<AnyCancellable> = []
    
    private var handleTap = false
    private var expandedIndexPaths: Set<IndexPath> = []
    private var dataSource: UICollectionViewDiffableDataSource<Int, TaskDisplay>?
    private var cells: [TaskDisplay] = []
    private lazy var dateLabel = UILabel()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)


    init(viewModel: any DayViewModeling) {
        self.viewModel = viewModel
        self.dateDisplay = DateDisplay(date: Date(), dateString: "")
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        setupContstraint()
        setupCollectionView()
        setupIndicator()
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
            self.taskDisplay = dispayData
            configureCells(with: taskDisplay)
        case .error:
            break
        }
    }

    override func configure(_ data: DateDisplay) {
        if dateDisplay != data {
            self.dateDisplay = data
            dateLabel.text = data.dateString
            activityIndicator.startAnimating()
            viewModel.trigger(.onLoad(data.date))
        }
    }

    private func setupIndicator() {
        activityIndicator.hidesWhenStopped = true
    }

    private func setupCollectionView() {
        collectionView.collectionViewLayout = createCompositionalLayout()
        collectionView.register(DayViewCell.self, forCellWithReuseIdentifier: DayViewCell.reuseIdentifier)
        collectionView.backgroundColor = .white
    }

    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, TaskDisplay>(collectionView: collectionView) { [weak self] _, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }

            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: DayViewCell.reuseIdentifier, for: indexPath) as? DayViewCell
            cell?.configure(task: item)

            cell?.processedTappedCompletedButton = { [weak self] id, value in
                guard let self = self else { return }
                viewModel.trigger(.processedTappedCompleted(id, indexPath.row ,value))
            }

            return cell ?? UICollectionViewCell()
        }
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, TaskDisplay>()
        snapshot.appendSections([0])
        snapshot.appendItems(cells)

        dataSource?.apply(snapshot)
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

    private func setupContstraint() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            collectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }


    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let isExpanded = { (indexPath: IndexPath) -> Bool in
                return self.expandedIndexPaths.contains(indexPath)
            }

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(100)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(isExpanded(IndexPath(item: sectionIndex, section: 0)) ? 200 : 100)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.interGroupSpacing = 10

            return section
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

