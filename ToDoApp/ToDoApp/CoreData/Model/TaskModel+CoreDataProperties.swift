//
//  TaskModel+CoreDataProperties.swift
//  ToDoApp
//
//  Created by surexnx on 27.08.2024.
//
//

import Foundation
import CoreData


extension TaskModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskModel> {
        return NSFetchRequest<TaskModel>(entityName: "TaskModel")
    }

    @NSManaged public var title: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var body: String?
    @NSManaged public var id: Int64
    @NSManaged public var dateCreated: Date
    @NSManaged public var taskTime: Date?
}

extension TaskModel : Identifiable {

}
