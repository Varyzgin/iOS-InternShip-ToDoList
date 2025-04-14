//
//  ToDo+CoreDataClass.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/26/25.
//
//

import Foundation
import CoreData

final class CoreManager {
    public static let shared = CoreManager()
    private init() {}

    //crud
    func createToDo(title: String, descript: String?, date: Date = Date.now, isDone: Bool = false) {
        let toDo = ToDo(context: persistentContainer.viewContext)
        toDo.title = title
        if let descript = descript {
            toDo.descript = descript
        }
        toDo.date = date
        toDo.isDone = isDone
        toDo.id = UUID().uuidString
        
        saveContext()
    }
    
    func readAllToDos() -> [ToDo] {
        let request = ToDo.fetchRequest()
        request.sortDescriptors = [
//            NSSortDescriptor(key: "isDone", ascending: true),
            NSSortDescriptor(key: "date", ascending: false)
        ]
        do {
            let toDos = try persistentContainer.viewContext.fetch(request)
            return toDos
        } catch {
            print("Bad request")
            return []
        }
    }
    
    func readToDo(id: String) -> ToDo? {
        let request = ToDo.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            let toDo = try persistentContainer.viewContext.fetch(request).first
            return toDo
        } catch {
            print("Bad request")
            return nil
        }
    }
    
    func updateToDo(id: String, title: String? = nil, descript: String? = nil, date: Date = Date.now, isDone: Bool = false) {
        let request = ToDo.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            let toDo = try persistentContainer.viewContext.fetch(request).first
            if let title = title {
                toDo?.title = title
            }
            if let descript = descript {
                toDo?.descript = descript
            }
            toDo?.date = date
            toDo?.isDone = isDone
            
            saveContext()
        } catch {
            print("Bad request")
        }
    }
    
    func deleteToDo(id: String) {
        let request = ToDo.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        if let toDo = readToDo(id: id) {
            persistentContainer.viewContext.delete(toDo)
            saveContext()
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "iOS_InternShip_ToDoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
