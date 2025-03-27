//
//  Builder.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/18/25.
//

import UIKit

final class Builder {
    public static func makeMainPage() -> UIViewController {
        let vc = MainPageViewController()
        let presenter = MainPagePresenter(view: vc)
        presenter.updateToDos()
        vc.presenter = presenter
        return vc
    }
}
