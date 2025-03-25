//
//  ContentMenuView.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/24/25.
//

import UIKit

final class ContentMenuView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMenu()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupMenu() {
        // 1. Создаем жестовый распознаватель
        let interaction = UIContextMenuInteraction(delegate: self)
        // 2. Добавляем его к UIView
        self.addInteraction(interaction)
        // 3. Включаем пользовательское взаимодействие
        self.isUserInteractionEnabled = true
    }
}

extension ContentMenuView: UIContextMenuInteractionDelegate {
    // 1. Возвращаем меню при нажатии
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let previewParameters = UIPreviewParameters()
           
           // 2. Устанавливаем отступы (10 пунктов со всех сторон)
           let expandedBounds = bounds.insetBy(dx: -10, dy: -10)
           previewParameters.visiblePath = UIBezierPath(roundedRect: expandedBounds, cornerRadius: 12)
           
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
                }
                
                // 3. Возвращаем меню с действиями
                return UIMenu(title: "", children: [share, delete])
            }
        )
    }
}
