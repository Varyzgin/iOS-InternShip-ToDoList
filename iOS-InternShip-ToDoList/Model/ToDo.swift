//
//  ToDo.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/19/25.
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

    @NSManaged public var title: String
    @NSManaged public var date: Date?
    @NSManaged public var descript: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var id: String

}

extension ToDo : Identifiable {

}

struct JSONReceiver : Decodable {
    let todos: [Note]
    let total: Int
    let skip: Int
    let limit: Int
    
    struct Note : Decodable {
        let id: Int
        let todo: String
        let completed: Bool
        let userId: Int
    }
    
    func recordToCoreData() {
        for note in todos {
            CoreManager.shared.createToDo(title: note.todo, descript: nil, date: Date.now, isDone: note.completed)
        }
    }
}



//struct ToDo {
//    let id: Int
//    var isDone: Bool
//    var title: String
//    var description: String?
//    var date: String
//
//    static func testData() -> [ToDo] {
//        [
//            ToDo(id: 1, isDone: true, title: "Почитать книгу", description: "Составить список необходимых продуктоСоставить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнСоставить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.ике.в для ужина. Не забыть проверить, чССоставить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.оставить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.то уже есть в холодильнике.", date: "09/10/24"),
//            ToDo(id: 2, isDone: false, title: "Уборка в квартире", description: "Провести генеральную уборку", date: "02/10/24"),
//            ToDo(id: 3, isDone: false, title: "Заняться спортом", description: "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!", date: "02/10/24"),
//            ToDo(id: 4, isDone: true, title: "Работа над проектом", description: "Выделить время для работы над проектом на работе. Сфокусироваться на выполнении важных задач", date: "09/10/24"),
//            ToDo(id: 5, isDone: false, title: "Вечерний отдых", description: "Найти время для расслабления перед сном: посмотреть фильм или послушать музыку", date: "02/10/24"),
//            ToDo(id: 6, isDone: false, title: "Зарядка утром", date: "12/10/24"),
//            ToDo(id: 7, isDone: false, title: "Испанский", description: "Провести 30 минут за изучением испанского языка с помощью приложения", date: "02/10/24"),
//            ToDo(id: 8, isDone: true, title: "Почитать книгу", description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.", date: "09/10/24"),
//            ToDo(id: 9, isDone: false, title: "Уборка в квартире", description: "Провести генеральную уборку в квартире", date: "02/10/24"),
//            ToDo(id: 10, isDone: false, title: "Заняться спортом", description: "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!", date: "02/10/24"),
//            ToDo(id: 11, isDone: true, title: "Работа над проектом", description: "Выделить время для работы над проектом на работе. Сфокусироваться на выполнении важных задач", date: "09/10/24"),
//            ToDo(id: 12, isDone: false, title: "Вечерний отдых", description: "Найти время для расслабления перед сном: посмотреть фильм или послушать музыку", date: "02/10/24"),
//            ToDo(id: 13, isDone: false, title: "Зарядка утром", date: "12/10/24"),
//            ToDo(id: 14, isDone: false, title: "Испанский", description: "Провести 30 минут за изучением испанского языка с помощью приложения", date: "02/10/24"),
//            ToDo(id: 15, isDone: true, title: "Почитать книгу", description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.", date: "09/10/24"),
//            ToDo(id: 16, isDone: false, title: "Уборка в квартире", description: "Провести генеральную уборку в квартире", date: "02/10/24"),
//            ToDo(id: 17, isDone: false, title: "Заняться спортом", description: "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!", date: "02/10/24"),
//            ToDo(id: 18, isDone: true, title: "Работа над проектом", description: "Выделить время для работы над проектом на работе. Сфокусироваться на выполнении важных задач", date: "09/10/24"),
//            ToDo(id: 19, isDone: false, title: "Вечерний отдых", description: "Найти время для расслабления перед сном: посмотреть фильм или послушать музыку", date: "02/10/24"),
//            ToDo(id: 20, isDone: false, title: "Зарядка утром", date: "12/10/24"),
//            ToDo(id: 21, isDone: false, title: "Испанский", description: "Провести 30 минут за изучением испанского языка с помощью приложения", date: "02/10/24"),
//        ]
//    }
//}
