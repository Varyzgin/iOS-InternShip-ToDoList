//
//  MainPageViewController.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/19/25.
//

import UIKit

protocol MainPageViewControllerProtocol: AnyObject {
    var data: [ToDo] { get set }
    var listTableView: UITableView { get set }
    var footerView: FooterView { get set }
}

final class MainPageViewController: UIViewController, MainPageViewControllerProtocol {
    public var presenter: MainPagePresenterProtocol!
    
    internal lazy var data: [ToDo] = []
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    internal lazy var footerView: FooterView = FooterView(frame: CGRect(x: 0, y: view.frame.maxY - 83, width: view.frame.width, height: 83), toDosCount: data.count - 1)
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
        self.data = CoreManager.shared.readAllToDos()
        data.append(ToDo())
        listTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        data.append(ToDo(id: -1, isDone: false, title: "", date: "")) // for whole last cell
        
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
    private var heightCache = [IndexPath: CGFloat]()
}

extension MainPageViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == data.count - 1 {
            return 50
        }
        ///Проверяем есть ли ячейка в кеше, если да, то достаем ее размер из кеша
        ///если нет, то вызываем статичный метод ячейки, которая считает свою высоту
//        if let cachedHeight = heightCache[indexPath] { return cachedHeight }
//        let calculatedHeight = ListCellView.calculateHeight(for: data[indexPath.section], screenWidth: tableView.frame.width)
//        heightCache[indexPath] = calculatedHeight
//        return calculatedHeight
        return ListCellView.calculateHeight(for: data[indexPath.section], screenWidth: tableView.frame.width)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsPageViewController()
        vc.configure(toDo: data[indexPath.section])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let previewParameters = UIPreviewParameters()
           
           // 2. Устанавливаем отступы (10 пунктов со всех сторон)
//           let expandedBounds = bounds.insetBy(dx: -10, dy: -10)
//           previewParameters.visiblePath = UIBezierPath(roundedRect: expandedBounds, cornerRadius: 12)
           
           // 3. Настраиваем прозрачный фон
           previewParameters.backgroundColor = .clear
        
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil, //{
//                // 4. Ваш контроллер предпросмотра
//                let previewController = CustomContentMenu(
//                    data: toDo,
//                    screenWidth: self.frame.width
//                )
//
//                // 5. Добавляем отступы внутри preview
//                previewController.additionalSafeAreaInsets = UIEdgeInsets(
//                    top: 10,
//                    left: 10,
//                    bottom: 10,
//                    right: 10
//                )
//
//                return previewController
//            },,
            actionProvider: { _ in
                // 2. Создаем действия для меню
                let share = UIAction(
                    title: "Поделиться",
                    image: UIImage(systemName: "square.and.arrow.up")
                ) { _ in
                    print("Поделиться нажато")
                }
                
                let delete = UIAction(
                    title: "Удалить",
                    image: UIImage(systemName: "trash"),
                    attributes: .destructive
                ) { _ in
                    print("Удалить нажато")
                    CoreManager.shared.deleteToDo(id: self.data[indexPath.section].id)
                    self.data = CoreManager.shared.readAllToDos()
                    tableView.reloadData()
//                    tableView.deleteSections([indexPath.section], with: .automatic)
                }
                
                // 3. Возвращаем меню с действиями
                return UIMenu(title: "", children: [share, delete])
            }
        )
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == data.count - 1 {
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
