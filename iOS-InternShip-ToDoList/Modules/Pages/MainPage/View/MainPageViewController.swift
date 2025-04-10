//
//  MainPageViewController.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/19/25.
//

import UIKit

protocol MainPageViewControllerProtocol: AnyObject {
    func updateDataSource()
    var footerView: FooterView { get set }
}

final class MainPageViewController: UIViewController, MainPageViewControllerProtocol {
    public var presenter: MainPagePresenterProtocol!
    
    enum Section {
        case done, notDone, main
    }
    
    var dataSource: UITableViewDiffableDataSource<Section, ToDo>!
    
    internal func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ToDo>()
        snapshot.appendSections([.main])
//        snapshot.appendSections([.notDone, .done])
//        var doneToDos: [ToDo] = []
//        var notDoneToDos: [ToDo] = []
//        for toDo in presenter.toDos {
//            if toDo.isDone {
//                doneToDos.append(toDo)
//            } else {
//                notDoneToDos.append(toDo)
//            }
//        }
//        snapshot.appendItems(notDoneToDos, toSection: .notDone)
        snapshot.appendItems(presenter.toDos, toSection: .done)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    internal lazy var footerView: FooterView = FooterView(frame: CGRect(x: 0, y: view.frame.maxY - 83, width: view.frame.width, height: 83), toDosCount: self.presenter.toDos.count - 1)
    
    internal lazy var listTableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
//        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ListCellView.self, forCellReuseIdentifier: ListCellView.id)
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 45, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name.reloadData, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = UISearchController()
        
        dataSource = UITableViewDiffableDataSource(tableView: listTableView, cellProvider: {
            tableView, indexPath, model -> UITableViewCell in
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCellView.id, for: indexPath) as? ListCellView else { return UITableViewCell() }
//            let item = self.presenter.toDos[indexPath.row]
                                                /// if first cell
            cell.configure(with: model as! ToDo, screenWidth: UIScreen.main.bounds.width)
            cell.selectionStyle = .none
            cell.completion = {
                self.presenter.checkoutTapped(id: model.id, isDone: model.isDone)
                NotificationCenter.default.post(name: Notification.Name.reloadData, object: nil)
            }

            return cell
        })
        
        view.backgroundColor = .background
        view.addSubview(listTableView)

        footerView.completion = { [weak self] in
            let vc = DetailsPageViewController()
            vc.configure(toDo: nil)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        view.addSubview(footerView)
    }
    private var cellSizesCache : [IndexPath: CGSize] = [:]
}

extension MainPageViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        ///Проверяем есть ли ячейка в кеше, если да, то достаем ее размер из кеша
        ///если нет, то вызываем статичный метод ячейки, которая считает свою высоту
//        if let cachedHeight = heightCache[indexPath] { return cachedHeight }
        let calculatedFrame = ContentLayout.calculateFrame(for: self.presenter.toDos[indexPath.row], screenWidth: tableView.frame.width)
        cellSizesCache[indexPath] = calculatedFrame
        return calculatedFrame.height
//        return ListCellView.calculateHeight(for: data[indexPath.row], screenWidth: tableView.frame.width)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsPageViewController()
        vc.configure(toDo: self.presenter.toDos[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let previewParameters = UIPreviewParameters()
           previewParameters.backgroundColor = .clear
        
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: {
                guard let cell = tableView.cellForRow(at: indexPath) as? ListCellView else {
                    return UIViewController()
                }

                let snapshot = cell.contentLayout.snapshotView(afterScreenUpdates: false) ?? cell.snapshotView(afterScreenUpdates: false)
                if let snapshot = snapshot {
                    return PreviewController(snapshot: snapshot)
                }
                return UIViewController()
            },
            actionProvider: { _ in
                let edit = UIAction(
                    title: "Редактировать",
                    image: UIImage(systemName: "square.and.pencil")
                ) { _ in
                    let vc = DetailsPageViewController()
                    vc.configure(toDo: self.presenter.toDos[indexPath.row])
                    self.navigationController?.pushViewController(vc, animated: true)                }
                
                let delete = UIAction(
                    title: "Удалить",
                    image: UIImage(systemName: "trash"),
                    attributes: .destructive
                ) { _ in
                    self.presenter.deleteItem(id: self.presenter.toDos[indexPath.row].id)
                    NotificationCenter.default.post(name: Notification.Name.reloadData, object: nil)
                }
                
                return UIMenu(title: "", children: [edit, delete])
            }
        )
    }
}
