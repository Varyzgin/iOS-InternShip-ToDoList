//
//  MainPageViewController.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/19/25.
//

import UIKit

protocol MainPageViewControllerProtocol: AnyObject {
    func reloadTable()
    func deletePerform(indexPath: IndexPath)
    var footerView: FooterView { get set }
}

final class MainPageViewController: UIViewController, MainPageViewControllerProtocol {
    public var presenter: MainPagePresenterProtocol!
        
    func deletePerform(indexPath: IndexPath) {
        self.listTableView.performBatchUpdates({
            self.listTableView.deleteRows(at: [indexPath], with: .automatic)
        }, completion: { _ in
            self.presenter.reloadTableShow()
        })
    }
    
    internal func reloadTable() {
//        UIView.transition(with: listTableView,
//                          duration: 0.6,
//                          options: .layoutSubviews,
//                          animations: {
                              self.listTableView.reloadData()
//                          },
//                          completion: nil)

    }
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width

    private lazy var searchController : UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.searchBar.delegate = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search ToDos"
        return controller
    }()
    
    internal lazy var footerView: FooterView = FooterView(frame: CGRect(x: 0, y: view.frame.maxY - 83, width: view.frame.width, height: 83), toDosCount: self.presenter.toDosToShow.count)
    
    internal lazy var listTableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ListCellView.self, forCellReuseIdentifier: ListCellView.id)
        tableView.contentInset.bottom = 55
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name.loadData, object: nil)
        if let searchText = searchController.searchBar.text {
            self.presenter.filterToDos(searchTerm: searchText)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.searchController = searchController
        
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
        self.presenter.toDosToShow.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ///Проверяем есть ли ячейка в кеше, если да, то достаем ее размер из кеша
        ///если нет, то вызываем статичный метод ячейки, которая считает свою высоту
//        if let cachedHeight = heightCache[indexPath] { return cachedHeight }
        let calculatedFrame = ContentLayout.calculateFrame(for: self.presenter.toDosToShow[indexPath.row], screenWidth: tableView.frame.width)
        cellSizesCache[indexPath] = calculatedFrame
        return calculatedFrame.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCellView.id, for: indexPath) as? ListCellView else { return UITableViewCell() }
        let item = self.presenter.toDosToShow[indexPath.row]
                                            /// if first cell
        cell.configure(with: item, isFirst: indexPath.row == 0, screenWidth: UIScreen.main.bounds.width)
        cell.selectionStyle = .none
        cell.completion = {
            self.presenter.checkoutTapped(indexPath: indexPath)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsPageViewController()
        vc.configure(toDo: self.presenter.toDosToShow[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let previewParameters = UIPreviewParameters()
           previewParameters.backgroundColor = .clear
        
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: {
                guard let cell = tableView.cellForRow(at: indexPath) as? ListCellView else { return UIViewController() }

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
                    vc.configure(toDo: self.presenter.toDosToShow[indexPath.row])
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                let delete = UIAction(
                    title: "Удалить",
                    image: UIImage(systemName: "trash"),
                    attributes: .destructive
                ) { _ in
                    self.presenter.deleteItem(indexPath: indexPath)
                }
                
                return UIMenu(title: "", children: [edit, delete])
            }
        )
    }
}

extension MainPageViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.presenter.filterToDos(searchTerm: searchController.searchBar.text)
    }
}

extension MainPageViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        self.presenter.reloadTableShowRaw()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        if let searchText = searchController.searchBar.text {
            self.presenter.filterToDos(searchTerm: searchText)
        }
    }
}
