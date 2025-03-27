//
//  MainPagePresenter.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/26/25.
//

import Foundation

protocol MainPagePresenterProtocol: AnyObject {
    var toDos: [ToDo] { get set }
    func updateToDos()
}

final class MainPagePresenter: MainPagePresenterProtocol {
    internal func updateToDos() {
        self.toDos = CoreManager.shared.readAllToDos()
        self.toDos.append(ToDo()) // для пустой ячейки снизу
        DispatchQueue.main.async {
            self.view?.footerView.countLabel.text = self.taskRus(number: self.toDos.count - 1) // минус пустая ячейка
            self.view?.listTableView.reloadData()
        }
    }
    
    private weak var view: MainPageViewControllerProtocol?
    
    internal var toDos: [ToDo] = CoreManager.shared.readAllToDos()
    
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
    
    init(view: MainPageViewControllerProtocol?) {
        self.view = view
        updateToDos()
    }
}
