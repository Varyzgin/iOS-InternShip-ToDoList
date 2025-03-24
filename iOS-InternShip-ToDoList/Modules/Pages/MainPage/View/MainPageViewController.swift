//
//  MainPageViewController.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/19/25.
//

import UIKit

final class MainPageViewController: UIViewController {
    private lazy var data : [ToDo] = ToDo.testData()
    private let screenWidth : CGFloat = UIScreen.main.bounds.width
    internal lazy var footerView : UIView = FooterView(frame: CGRect(x: 0, y: view.frame.maxY - 83, width: view.frame.width, height: 83), toDosCount: data.count - 1)
    private lazy var listTableView : UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.register(ListCellView.self, forCellReuseIdentifier: ListCellView.id)
        $0.register(WholeCellView.self, forCellReuseIdentifier: WholeCellView.id)
        return $0
    }(UITableView(frame: view.frame, style: .plain))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data.append(ToDo(isDone: false, title: "", date: "")) // for whole last cell
        
//        navigationItem.title = "Задачи"
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.searchController = UISearchController()
        
        view.backgroundColor = .background
        view.addSubview(listTableView)
        
//        view.addSubview(footerView)
    }
    private var heightCache = [IndexPath: CGFloat]()
}

extension MainPageViewController : UITableViewDelegate, UITableViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
//        return UIContextMenuConfiguration(actionProvider: { suggestedActions in
//            if indexPaths.count == 0 {
//                // Construct an empty-space menu.
//                return UIMenu(children: [
//                    UIAction(title: "New Folder") { _ in /* Implement the action. */
//                    print("8kok")}
//                ])
//            }
//            else if indexPaths.count == 1 {
//                // Construct a single-item menu.
//                return UIMenu(children: [
//                    UIAction(title: "Copy") { _ in /* Implement the action. */print("5kok") },
//                    UIAction(title: "Delete", attributes: .destructive) { _ in /* Implement the action. */ print("6kok")}
//                ])
//            }
//            else {
//                // Construct a multiple-item menu.
//                return UIMenu(children: [
//                    UIAction(title: "New Folder With Selection") { _ in /* Implement the action. */print("3kok") }
//                ])
//            }
//        })
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ///Проверяем есть ли ячейка в кеше, если да, то достаем ее размер из кеша
        ///если нет, то вызываем статичный метод ячейки, которая считает свою высоту
        if let cachedHeight = heightCache[indexPath] { return cachedHeight }
        let calculatedHeight = ListCellView.calculateHeight(for: data[indexPath.section], screenWidth: tableView.frame.width)
        heightCache[indexPath] = calculatedHeight
        return calculatedHeight
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == data.count - 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WholeCellView.id, for: indexPath) as? WholeCellView else { return UITableViewCell() }
            cell.configure(size: CGSize(width: UIScreen.main.bounds.width, height: 45))
            cell.selectionStyle = .none
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCellView.id, for: indexPath) as? ListCellView else { return UITableViewCell() }
                                                            /// if first cell
        cell.configure(with: data[indexPath.section], isFirst: indexPath.section == 0, screenWidth: UIScreen.main.bounds.width)
        cell.selectionStyle = .none
        return cell
    }
}
