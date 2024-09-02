//
//  CoreDataManager.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//

import Foundation
import CoreData

protocol UserCoreData {
    func createUser() -> UserModel
    func fetchUser(id: Int, completion: @escaping (UserModel?) -> ())
    func setCurrentUser(user: UserModel)
}

final class CoreDataManager: UserCoreData {

    static let shared = CoreDataManager()
    private let dateTimeHelper: DateTimeHelper
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private var currenUser: UserModel?
    private var users: Set<Int64> = []
    private let defaultsSevice: UserDefaultsService<Int64>
    private let taskService: UserDefaultsService<Int64>

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
        let encoder = JSONEncoder()
        defaultsSevice = UserDefaultsService<Int64>("user", encoder: encoder)
        taskService = UserDefaultsService<Int64>("task", encoder: encoder)

        dateTimeHelper = DateTimeHelper()
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

            defaultsSevice.setAll(Set(users.keys))
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

    func deleteAllData() {
        let entities = persistentContainer.managedObjectModel.entities
        entities.compactMap({ $0.name }).forEach { entityName in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try viewContext.execute(batchDeleteRequest)
                saveContext()
            } catch {
                print("Failed to delete entity \(entityName): \(error)")
            }
        }
    }

    func toggleCompleted(_ taskId: Int, completion: @escaping (Bool?) -> ()) {
        let fetchRequest: NSFetchRequest<TaskModel> = TaskModel.fetchRequest()
        fetchRequest.fetchLimit = 1

        fetchRequest.predicate = NSPredicate(format: "id == %d", Int64(taskId))
        DispatchQueue.global().async {
            do {
                let tasks = try self.viewContext.fetch(fetchRequest)
                let task = tasks.first
                task?.isCompleted.toggle()
                self.saveContext()
                DispatchQueue.main.async {
                    completion(task?.isCompleted)
                }
            } catch {
                print("Error fetching task: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

    func createUser(id: Int64) -> UserModel {
        let user = UserModel(context: viewContext)
        user.id = id
        return user
    }

    private func generateNextUserID() -> Int64 {
        guard let maxID = defaultsSevice.get().max() else {
            return 1
        }
        defaultsSevice.set(maxID + 1)

        return maxID + 1
    }

    private func generateNextTaskID() -> Int64 {
        guard let maxID = taskService.get().max() else {
            return 1
        }
        taskService.set(maxID + 1)

        return maxID + 1
    }

    func createUser() -> UserModel {
        let user = UserModel(context: viewContext)
        let id = generateNextUserID()
        user.id = id
        saveContext()
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
        day.date = dateTimeHelper.getStartNowDate()
        day.user = user
        return day
    }

    private func createTask(todo: Todo) -> TaskModel {
        let task = TaskModel(context: viewContext)
        task.id = todo.id
        task.body = todo.todo
        task.dateCreated = dateTimeHelper.nowDate()
        task.isCompleted = todo.completed
        taskService.set(task.id)
        return task
    }

    func updateTask(_ value: TaskEntity, completion: @escaping (TaskModel?, Date?) -> ()) {

        DispatchQueue.global().async {
            let fetch = TaskModel.fetchRequest()
            fetch.predicate = NSPredicate(format: "id == %d", value.id)
            let task = try? self.viewContext.fetch(fetch).first

            guard
                let _ = self.currenUser,
                let task = task
            else {
                return DispatchQueue.main.async {
                    completion(nil, nil)
                }
            }
            task.taskTime = value.isTime ? value.taskTime : nil
            task.body = value.body
            self.saveContext()

            let fetchDay = Day.fetchRequest()
            fetchDay.predicate = NSPredicate(format: "ANY tasks == %@", task)
            let day = try? self.viewContext.fetch(fetchDay).first

            DispatchQueue.main.async {
                completion(task, day?.date)
            }

        }
    }

    func createTask(_ value: TaskEntity, completion: @escaping (TaskModel?, Date?) -> ()) {

        DispatchQueue.global().async {
            guard
                let user = self.currenUser
            else {
                return DispatchQueue.main.async {
                    completion(nil, nil)
                }
            }
            var day = user.days.first(where: { $0.date == self.dateTimeHelper.startOfDay(for: value.taskTime) })
            if day == nil {
                day = Day(context: self.viewContext)
                day?.user = user
                day?.date = self.dateTimeHelper.startOfDay(for: value.taskTime)
            }

            let task = TaskModel(context: self.viewContext)
            task.dateCreated = Date()
            task.body = value.body
            task.isCompleted = false
            task.id = self.generateNextTaskID()
            task.taskTime = value.isTime ? value.taskTime : nil
            day?.addToTasks(task)
            self.saveContext()

            DispatchQueue.main.async {
                completion(task, day?.date)
            }
        }
    }

    func fetchUsers() -> [UserModel]? {
        let fetch = UserModel.fetchRequest()
        let users = try? viewContext.fetch(fetch)
        return users
    }

    func fetchUser(id: Int, completion: @escaping (UserModel?) -> ()) {
        DispatchQueue.global().async {
            let fetch = UserModel.fetchRequest()
            fetch.predicate = NSPredicate(format: "id == %d", id)
            let user = try? self.viewContext.fetch(fetch).first

            DispatchQueue.main.async {
                completion(user)
            }
        }
    }

    func deleteTask(id: Int, completion: @escaping (Bool) -> ()) {
        DispatchQueue.global().async {
            let fetch = TaskModel.fetchRequest()
            fetch.predicate = NSPredicate(format: "id == %d", id)
            let task = try? self.viewContext.fetch(fetch).first
            guard
                let user = self.currenUser,
                let task = task
            else {
                return DispatchQueue.main.async {
                    completion(false)
                }
            }
            self.viewContext.delete(task)
            self.saveContext()
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }

    func setCurrentUser(user: UserModel) {
        currenUser = user
    }

    // MARK: Time and date queries

    func fetchTasks(user: UserModel, for date: Date) -> [TaskModel] {
        let startOfDay = dateTimeHelper.startOfDay(for: date)
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

    func fetchTaskForDate(for date: Date, completion: @escaping ([TaskModel]) ->()) {
        DispatchQueue.global().async {
            guard let user = self.currenUser else {
                return DispatchQueue.main.async {
                    completion([])
                }
            }
            let startOfDay = self.dateTimeHelper.startOfDay(for: date)
            let fetchRequest: NSFetchRequest<Day> = Day.fetchRequest()

            fetchRequest.predicate = NSPredicate(format: "date == %@ AND user == %@", startOfDay as NSDate, user)

            do {
                let result = try self.viewContext.fetch(fetchRequest).first?.tasks ?? []
                let tasksArray = Array(result)
                DispatchQueue.main.async {
                    completion(tasksArray)
                }
            } catch {
                print("Error fetching tasks: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }

    func fetchAfterDay(for today: Date) -> DayEntity {
        let tomorrow = dateTimeHelper.tomorrow(for: today)
        var dayEntity = DayEntity(date: tomorrow, tasks: [])
        guard let user = currenUser else { return DayEntity(date: tomorrow, tasks: []) }

        let fetch = fetchTasks(user: user, for: tomorrow)
        dayEntity.tasks.append(contentsOf: fetchTasks(user: user, for: tomorrow))

        return DayEntity(date: tomorrow, tasks: fetch)
    }

    func fetchBeforeDay(for today: Date) -> DayEntity {
        let yesterday = dateTimeHelper.yesterday(for: today)
        var dayEntity = DayEntity(date: yesterday, tasks: [])

        guard let user = currenUser else { return dayEntity }

        dayEntity.tasks.append(contentsOf: fetchTasks(user: user, for: yesterday))

        return dayEntity
    }
}
