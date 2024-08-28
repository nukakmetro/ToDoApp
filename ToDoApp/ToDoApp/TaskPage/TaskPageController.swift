//
//  TaskPageController.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//

import Foundation
import UIKit
import Combine
// import SnapKit

final class TasksPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private var cancellables: Set<AnyCancellable> = []
    private var current = 1
    private var days: [DayDisplay] = []
    private var viewModel: any TaskPageViewModeling
    private var controllers: [DayViewController]
    private var count = 1

    private lazy var pageController: UIPageViewController = {
        return UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }()

    init(viewModel: any TaskPageViewModeling) {
        AuthorizationService().authorizate(id: 152)
        self.viewModel = viewModel
        let firstVC = DayViewController(.blue)
        let secondVC = DayViewController(.yellow)
        let threeVC = DayViewController(.cyan)
        controllers = [firstVC, secondVC, threeVC]
        firstVC.view.tag = 0
        secondVC.view.tag = 1
        threeVC.view.tag = 2
        super.init(nibName: nil, bundle: nil)
    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        makeConstraint()
        setupPageController()
        configureIO()
        viewModel.trigger(.onLoad)

    }

    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(processedTappedAdd))
        navigationItem.rightBarButtonItems = [addButton]
    }

    @objc private func processedTappedAdd(){

    }

    func setupPageController() {
        pageController.dataSource = self
        pageController.delegate = self
        pageController.setViewControllers([controllers[1]], direction: .forward, animated: true, completion: nil)

    }

    func createDayTasks(for date: Date) -> DayTasks {
        let tasks = [Task(title: "Task 1", isCompleted: false)]
        return DayTasks(date: date, tasks: tasks)
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
            controllers[0].configure(with: dispayData[0])
            controllers[1].configure(with: dispayData[1])
            controllers[2].configure(with: dispayData[2])
        case .error:
            break
        }
    }

    private func makeConstraint() {
        addChild(pageController)
        view.addSubview(pageController.view)
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               pageController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
               pageController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
               pageController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               pageController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
           ])
    }

    // MARK: - DataSource Methods

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
       // controllers.swapAt(0, 1)
        var pageIndex = viewController.view.tag - 1
        if pageIndex < 0 {
            pageIndex = 2
        }
        var updateIndex = pageIndex - 1
        if updateIndex < 0 {
            updateIndex = 2
        }
        viewModel.trigger(.processedScrolledBack(pageIndex, updateIndex))
        return controllers[pageIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var pageIndex = viewController.view.tag + 1
        if pageIndex > 2 {
            pageIndex = 0
        }
        var updateIndex = pageIndex + 1
        if updateIndex > 2 {
            updateIndex = 0
        }
        viewModel.trigger(.processedScrolledForward(pageIndex, updateIndex))
        return controllers[pageIndex]
    }
}
