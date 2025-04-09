//
//  MainPageViewController.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/19/25.
//

import UIKit

protocol MainPageViewControllerProtocol: AnyObject {
    func reloadListTableView()
    var footerView: FooterView { get set }
}

final class MainPageViewController: UIViewController, MainPageViewControllerProtocol {
    public var presenter: MainPagePresenterProtocol!
    
    internal func reloadListTableView() {
//        UIView.transition(with: listTableView,
//                          duration: 0.6,
//                          options: .layoutSubviews,
//                          animations: {
                              self.listTableView.reloadData()
//                          },
//                          completion: nil)

    }
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    internal lazy var footerView: FooterView = FooterView(frame: CGRect(x: 0, y: view.frame.maxY - 83, width: view.frame.width, height: 83), toDosCount: self.presenter.toDos.count - 1)
    
    internal lazy var listTableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.register(ListCellView.self, forCellReuseIdentifier: ListCellView.id)
        $0.register(WholeCellView.self, forCellReuseIdentifier: WholeCellView.id)
        return $0
    }(UITableView(frame: view.frame, style: .plain))
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name.reloadData, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = UISearchController()
        
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

extension MainPageViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter.toDos.count
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        self.presenter.toDos.count
//    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.presenter.toDos.count - 1 {
            return 50
        }
        ///Проверяем есть ли ячейка в кеше, если да, то достаем ее размер из кеша
        ///если нет, то вызываем статичный метод ячейки, которая считает свою высоту
//        if let cachedHeight = heightCache[indexPath] { return cachedHeight }
        let calculatedFrame = ContentLayout.calculateFrame(for: self.presenter.toDos[indexPath.row], screenWidth: tableView.frame.width)
        cellSizesCache[indexPath] = calculatedFrame
        return calculatedFrame.height
//        return ListCellView.calculateHeight(for: data[indexPath.row], screenWidth: tableView.frame.width)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.presenter.toDos.count - 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WholeCellView.id, for: indexPath) as? WholeCellView else { return UITableViewCell() }
            cell.configure(size: CGSize(width: UIScreen.main.bounds.width, height: 45))
            cell.selectionStyle = .none
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCellView.id, for: indexPath) as? ListCellView else { return UITableViewCell() }
        let item = self.presenter.toDos[indexPath.row]
                                            /// if first cell
        cell.configure(with: item, isFirst: indexPath.row == 0, screenWidth: UIScreen.main.bounds.width)
        cell.selectionStyle = .none
        cell.completion = {
            self.presenter.checkoutTapped(id: item.id, isDone: item.isDone)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != presenter.toDos.count - 1 {
            let vc = DetailsPageViewController()
            vc.configure(toDo: self.presenter.toDos[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if indexPath.row == presenter.toDos.count - 1 {
            return nil // off UIMenu for WholeCell
        }
        
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
                    
                    self.listTableView.performBatchUpdates({
                        self.listTableView.deleteRows(at: [indexPath], with: .automatic)
                    }, completion: { _ in
                        // Это выполнится после завершения анимации удаления
                        self.listTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none) // to remove line of second cell
                    })
                }
                
                return UIMenu(title: "", children: [edit, delete])
            }
        )
    }
}
