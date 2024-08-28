//
//  Day+CoreDataProperties.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var date: Date?
    @NSManaged public var tasks: Set<TaskModel>
    @NSManaged public var user: UserModel?

}

// MARK: Generated accessors for tasks
extension Day {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: TaskModel)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: TaskModel)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: Set<TaskModel>)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension Day : Identifiable {

}
