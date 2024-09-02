//
//  TaskPageController.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//

import Foundation
import UIKit
import Combine

final class TasksPageViewController: UIViewController {
    var currentPageIndex: Int = 1

    private var cancellables: Set<AnyCancellable> = []
    private var days: [DayDisplay] = []
    private var viewModel: any TaskPageViewModeling
    private var controllers: [CustomViewController<DateDisplay, TaskDisplay>]

    private lazy var pageController: UIPageViewController = {
        return UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }()

    // MARK: Initialization

    init(viewModel: any TaskPageViewModeling, controllers: [CustomViewController<DateDisplay, TaskDisplay>]) {
        self.viewModel = viewModel
        viewModel.trigger(.willLoad)
        self.controllers = controllers

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        makeConstraint()
        configureIO()
        viewModel.trigger(.onLoad)

    }

    private func setupView() {
        setupPageController()
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(processedTappedAdd))
        navigationItem.rightBarButtonItems = [addButton]
    }

    @objc private func processedTappedAdd() {
        viewModel.trigger(.processedTappedAddButton)
    }

    private func setupPageController() {

        for controller in controllers {
            controller.processedTappedCell = { [weak self] task in
                self?.viewModel.trigger(.processedTappedCell(task))
            }
        }
        pageController.dataSource = self
        pageController.delegate = self
        pageController.setViewControllers([controllers[1]], direction: .forward, animated: true, completion: nil)

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
            controllers[0].configure(dispayData[0])
            controllers[1].configure(dispayData[1])
            controllers[2].configure(dispayData[2])
        case .error:
            break
        }
    }

    private func makeConstraint() {
        addChild(pageController)
        view.addSubview(pageController.view)
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([

            pageController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            pageController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UIPageViewControllerDataSource

extension TasksPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var pageIndex = viewController.view.tag - 1
        if pageIndex < 0 {
            pageIndex = 2
        }
        return controllers[pageIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var pageIndex = viewController.view.tag + 1
        if pageIndex > 2 {
            pageIndex = 0
        }

        return controllers[pageIndex]
    }

}
// MARK: - UIPageViewControllerDelegate

extension TasksPageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first {
            let newPageIndex = visibleViewController.view.tag

            if newPageIndex == (currentPageIndex + 1) % controllers.count || (currentPageIndex == controllers.count - 1 && newPageIndex == 0) {

                var updateIndex = newPageIndex + 1
                if updateIndex > 2 {
                    updateIndex = 0
                }
                viewModel.trigger(.processedScrolledForward(newPageIndex, updateIndex))

            } else {

                var updateIndex = newPageIndex - 1
                if updateIndex < 0 {
                    updateIndex = 2
                }
                viewModel.trigger(.processedScrolledBack(newPageIndex, updateIndex))
            }
            currentPageIndex = newPageIndex
        }
    }
}
