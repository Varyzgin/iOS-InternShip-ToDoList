//
//  MainPagePresenter.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/26/25.
//

import Foundation

protocol MainPagePresenterProtocol: AnyObject {
    func reloadTableShowRaw()
    func reloadTableShow()
    func deleteItem(indexPath: IndexPath)
    func filterToDos(searchTerm: String?)
    func checkoutTapped(indexPath: IndexPath)
    var toDosToShow: [ToDo] { get }
}

final class MainPagePresenter: MainPagePresenterProtocol {
    private weak var view: MainPageViewControllerProtocol?
    
    private var toDos: [ToDo] = []
    internal var toDosToShow: [ToDo] = []
    
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
    
    @objc func loadTableData() {
        self.toDos = CoreManager.shared.readAllToDos()
        self.toDosToShow = self.toDos
        DispatchQueue.main.async {
            self.view?.reloadTable()
            self.view?.footerView.countLabel.text = self.taskRus(number: self.toDosToShow.count)
        }
    }
    
    func reloadTableShowRaw() {
        self.toDosToShow = self.toDos
        DispatchQueue.main.async {
            self.view?.reloadTable()
            self.view?.footerView.countLabel.text = self.taskRus(number: self.toDosToShow.count)
        }
    }
    
    func reloadTableShow() {
        DispatchQueue.main.async {
            self.view?.reloadTable()
            self.view?.footerView.countLabel.text = self.taskRus(number: self.toDosToShow.count)
        }
    }
    
    internal func filterToDos(searchTerm: String?) {
        if let search = searchTerm {
            if search.count > 0 {
                self.toDosToShow = self.toDos
                let search = search.lowercased()
                let filteredResults = self.toDos.filter {
                    $0.title.lowercased().contains(search) ||
                    $0.descript?.lowercased().contains(search) ?? false
                }
                self.toDosToShow = filteredResults
                reloadTableShow()
            } else {
                reloadTableShowRaw()
            }
        }
    }
    
    public func deleteItem(indexPath: IndexPath) {
        // change core
        let id = self.toDosToShow[indexPath.row].id
        CoreManager.shared.deleteToDo(id: id)
        
        // change raw
        self.toDos = CoreManager.shared.readAllToDos()

        // change show
        self.toDosToShow.remove(at: indexPath.row)
        
        // perform
        self.view?.deletePerform(indexPath: indexPath)
    }
    
    public func checkoutTapped(indexPath: IndexPath) {
        // change core
        let id = self.toDosToShow[indexPath.row].id
        let isDone = self.toDosToShow[indexPath.row].isDone
        CoreManager.shared.updateToDo(id: id, date: self.toDosToShow[indexPath.row].date ?? Date.now, isDone: !isDone)
        
        // change show
//        let ToDo = self.toDosToShow[indexPath.row]
//        ToDo.isDone = !isDone
//        self.toDosToShow[indexPath.row] = ToDo

        // perform
        reloadTableShow()
    }

    public init(view: MainPageViewControllerProtocol?) {
        self.view = view
        loadTableData()
        NotificationCenter.default.addObserver(self, selector: #selector(loadTableData), name: Notification.Name.loadData, object: nil)
    }
}
