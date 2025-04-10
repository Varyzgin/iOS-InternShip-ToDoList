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
    
    private var toDosToShow: [ToDo] = []
    
    private lazy var searchController : UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.searchBar.delegate = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search ToDos"
        return controller
    }()
    
    private func filterCurrentDataSource(searchTerm: String) {
        if searchTerm.count > 2 {
            self.toDosToShow = self.presenter.toDos
            let searchTerm = searchTerm.lowercased()
            let filteredResults = self.toDosToShow.filter {
                $0.title.lowercased().contains(searchTerm) ||
                $0.descript?.lowercased().contains(searchTerm) ?? false
            }
            toDosToShow = filteredResults
            listTableView.reloadData()
        } else {
            toDosToShow = self.presenter.toDos
            listTableView.reloadData()
        }
    }
    
//    private func restoreDisplayedDataSource() {
//        self.toDosToShow = self.presenter.toDos
//        listTableView.reloadData()
//    }
    
    internal func reloadListTableView() {
        toDosToShow = presenter.toDos
//        UIView.transition(with: listTableView,
//                          duration: 0.6,
//                          options: .layoutSubviews,
//                          animations: {
                              self.listTableView.reloadData()
//                          },
//                          completion: nil)

    }
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    internal lazy var footerView: FooterView = FooterView(frame: CGRect(x: 0, y: view.frame.maxY - 83, width: view.frame.width, height: 83), toDosCount: toDosToShow.count - 1)
    
    internal lazy var listTableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ListCellView.self, forCellReuseIdentifier: ListCellView.id)
        tableView.contentInset.bottom = 83
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name.reloadData, object: nil)
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
        toDosToShow.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ///Проверяем есть ли ячейка в кеше, если да, то достаем ее размер из кеша
        ///если нет, то вызываем статичный метод ячейки, которая считает свою высоту
//        if let cachedHeight = heightCache[indexPath] { return cachedHeight }
        let calculatedFrame = ContentLayout.calculateFrame(for: toDosToShow[indexPath.row], screenWidth: tableView.frame.width)
        cellSizesCache[indexPath] = calculatedFrame
        return calculatedFrame.height
//        return ListCellView.calculateHeight(for: data[indexPath.row], screenWidth: tableView.frame.width)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCellView.id, for: indexPath) as? ListCellView else { return UITableViewCell() }
        let item = toDosToShow[indexPath.row]
                                            /// if first cell
        cell.configure(with: item, isFirst: indexPath.row == 0, screenWidth: UIScreen.main.bounds.width)
//        cell.selectionStyle = .none
        cell.completion = {
            self.presenter.checkoutTapped(id: item.id, isDone: item.isDone)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsPageViewController()
        vc.configure(toDo: toDosToShow[indexPath.row])
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
                    vc.configure(toDo: self.toDosToShow[indexPath.row])
                    self.navigationController?.pushViewController(vc, animated: true)                }
                
                let delete = UIAction(
                    title: "Удалить",
                    image: UIImage(systemName: "trash"),
                    attributes: .destructive
                ) { _ in
                    self.presenter.deleteItem(id: self.toDosToShow[indexPath.row].id)
                    
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

extension MainPageViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterCurrentDataSource(searchTerm: searchText)
        }
    }
    
    
}

extension MainPageViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            toDosToShow = presenter.toDos
            self.listTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        if let searchText = searchController.searchBar.text {
            filterCurrentDataSource(searchTerm: searchText)
        }
    }
}
