//
//  UIView.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/20/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func translateAutoresizingMaskIntoConstraintsActivate(_ views: UIView...) {
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
}
