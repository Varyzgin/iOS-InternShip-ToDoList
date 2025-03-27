//
//  ToDo+CoreDataClass.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/26/25.
//
//

import Foundation
import CoreData

@objc(ToDo)
public class ToDo: NSManagedObject {

}

extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var descript: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var id: String?

}

extension ToDo : Identifiable {

}
