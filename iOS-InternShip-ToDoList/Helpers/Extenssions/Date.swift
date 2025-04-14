//
//  Date.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/26/25.
//

import Foundation

extension Date {
    func formattedDDMMYY() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: self)
    }
}
