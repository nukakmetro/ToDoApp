//
//  CoreDataManager.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private var currenUser: UserModel?

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoApp")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    init() {
        let fetch = UserModel.fetchRequest()
        fetch.fetchLimit = 1

        let result = try? viewContext.fetch(fetch)
        if result?.count == 0 {
            let todos = ParseService().parseTodo()
            var users: [Int64: [Todo]] = [:]

            todos.todos.forEach { todo in
                users[todo.userId, default: []].append(todo)
            }
            var userModels: [UserModel] = []

            users.forEach { (userId: Int64, todos: [Todo]) in
                let user = createUser(id: userId)
                let day = createDay(for: user)
                day.addToTasks(Set(createTasks(todos: todos)))
                user.addToDays(day)
                userModels.append(user)
            }

            saveContext()
        }
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func createUser(id: Int64) -> UserModel {
        let user = UserModel(context: viewContext)
        user.id = id
        return user
    }

    func createTasks(todos: [Todo]) -> [TaskModel] {
        var tasks: [TaskModel] = []
        todos.forEach { todo in
            tasks.append(createTask(todo: todo))
        }
        return tasks
    }

    func createDay(for user: UserModel) -> Day {
        let day = Day(context: viewContext)
        day.date = Calendar.current.startOfDay(for: Date())
        day.user = user
        return day
    }

    func createTask(todo: Todo) -> TaskModel {
        let task = TaskModel(context: viewContext)
        task.id = todo.id
        task.body = todo.todo
        task.dateCreated = Date()
        task.isCompleted = todo.completed
        return task
    }

    func fetchTasksForDay(for date: Date) {

    }
    func fetchUsers() -> [UserModel]? {
        let fetch = UserModel.fetchRequest()
        let users = try? viewContext.fetch(fetch)
        return users
    }

    func fetchUser(id: Int) -> UserModel? {
        let fetch = UserModel.fetchRequest()
        let user = try? viewContext.fetch(fetch).first(where: { $0.id == Int64(id) })
        return user
    }

    func setCurrentUser(user: UserModel) {
        currenUser = user
    }

    func fetchTaskForYTT(for date: Date) -> ([DayEntity]) {
        let calendar = Calendar.current
        let today = date

        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? Date(timeIntervalSinceNow: -86400)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? Date(timeIntervalSinceNow: 86400)
        var tasksForYesterday = DayEntity(date: yesterday, tasks: [])
        var tasksForToday = DayEntity(date: today, tasks:  [])
        var tasksForTomorrow = DayEntity(date: tomorrow, tasks: [])
        guard let user = currenUser else { return [tasksForYesterday, tasksForToday, tasksForTomorrow] }
        tasksForYesterday.tasks.append(contentsOf: fetchTasks(user: user, for: today))
        tasksForToday.tasks.append(contentsOf: fetchTasks(user: user, for: yesterday))
        tasksForTomorrow.tasks.append(contentsOf: fetchTasks(user: user, for: tomorrow))


        return [tasksForYesterday, tasksForToday, tasksForTomorrow]
    }
    
    func fetchTasks(user: UserModel, for date: Date) -> [TaskModel] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let fetchRequest: NSFetchRequest<Day> = Day.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "date == %@ AND user == %@", startOfDay as NSDate, user)

        do {
            let days = try viewContext.fetch(fetchRequest)
            return Array(days.first?.tasks ?? [])
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }

    func fetchAfterDay(for today: Date) -> DayEntity {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? Date(timeIntervalSinceNow: 86400)
        var dayEntity = DayEntity(date: tomorrow, tasks: [])
        guard let user = currenUser else { return DayEntity(date: tomorrow, tasks: []) }

        let fetch = fetchTasks(user: user, for: tomorrow)
        dayEntity.tasks.append(contentsOf: fetchTasks(user: user, for: tomorrow))

        return DayEntity(date: tomorrow, tasks: fetch)
    }

    func fetchBeforeDay(for today: Date) -> DayEntity {
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? Date(timeIntervalSinceNow: -86400)
        var dayEntity = DayEntity(date: yesterday, tasks: [])

        guard let user = currenUser else { return dayEntity }

        dayEntity.tasks.append(contentsOf: fetchTasks(user: user, for: yesterday))

        return dayEntity
    }

}
