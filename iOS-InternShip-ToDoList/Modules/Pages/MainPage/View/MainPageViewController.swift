//
//  MainPageViewController.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/19/25.
//

import UIKit

final class MainPageViewController: UIViewController {
    lazy var data : [ToDo] = ToDo.testData()
    let screenWidth : CGFloat = UIScreen.main.bounds.width
    internal lazy var footerView : UIView = FooterView(frame: CGRect(x: 0, y: view.frame.maxY - 83, width: view.frame.width, height: 83), toDosCount: data.count - 1)
    
    lazy var listTableView : UITableView = {
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
        data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var result = Margins.S + 21 + Margins.XS + 17 + Margins.S
//        print(data[indexPath.row].description)
        if let text = data[indexPath.row].description {
            let delta = DynamicFont.calculateTextHeight(for: text, with: UIFont.preferredFont(forTextStyle: .body), maxWidth: UIScreen.main.bounds.width - 2 * Margins.M - Margins.XS - 32)
//            print(delta)
            result += delta
        }
        return result
//        100
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
        cell.configure(with: data[indexPath.row], isFirst: indexPath.item == 0, screenWidth: UIScreen.main.bounds.width)
        cell.selectionStyle = .none
        return cell
    }
}
