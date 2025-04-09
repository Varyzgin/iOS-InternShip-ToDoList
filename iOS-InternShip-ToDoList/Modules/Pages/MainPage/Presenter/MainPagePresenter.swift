//
//  MainPagePresenter.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/26/25.
//

import Foundation

protocol MainPagePresenterProtocol: AnyObject {
    var toDos: [ToDo] { get set }
    func deleteItem(id: String)
    func checkoutTapped(id: String, isDone: Bool)
}

final class MainPagePresenter: MainPagePresenterProtocol {
    private weak var view: MainPageViewControllerProtocol?
    
    internal var toDos: [ToDo] = []
    
    private func taskRus(number toDosCount: Int ) -> String {
        if toDosCount % 10 == 1 && toDosCount % 100 != 11 {
            return "\(toDosCount) Задачa"
        } else if (toDosCount % 10 == 2 || toDosCount % 10 == 3 || toDosCount % 10 == 4)
                    && toDosCount % 100 != 12 && toDosCount % 100 != 13 && toDosCount % 100 != 14 {
            return "\(toDosCount) Задачи"
        } else {
            return "\(toDosCount) Задач"
        }
    }
    
    @objc func reloadTableData() {
        self.toDos = CoreManager.shared.readAllToDos()
        self.toDos.append(ToDo()) // для пустой ячейки снизу
        DispatchQueue.main.async {
            self.view?.reloadListTableView()
            self.view?.footerView.countLabel.text = self.taskRus(number: self.toDos.count - 1) // минус пустая ячейка
        }
    }
    
    public func deleteItem(id: String) {
        CoreManager.shared.deleteToDo(id: id)
        self.toDos = CoreManager.shared.readAllToDos()
        self.toDos.append(ToDo()) // для пустой ячейки снизу
        DispatchQueue.main.async {
            self.view?.footerView.countLabel.text = self.taskRus(number: self.toDos.count - 1) // минус пустая ячейка
        }
    }
    
    public func checkoutTapped(id: String, isDone: Bool) {
        CoreManager.shared.updateToDo(id: id, isDone: !isDone)
        self.reloadTableData()
    }

    public init(view: MainPageViewControllerProtocol?) {
        self.view = view
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: Notification.Name.reloadData, object: nil)
    }
}
