//
//  FooterView.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/20/25.
//

import UIKit

final class FooterView: UIView {
    private lazy var footerView : UIVisualEffectView = {
        $0.effect = UIBlurEffect(style: .systemMaterial)
        return $0
    }(UIVisualEffectView(frame: self.bounds))
    
    private lazy var countLabel : UILabel = {
        $0.textColor = .primaryText
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 12)
        return $0
    }(UILabel(frame: CGRect(x: self.bounds.midX - 40, y: self.bounds.minY + 18, width: 80, height: 13)))
    
    private lazy var addButton: UIImageView = {
        $0.isUserInteractionEnabled = true
        $0.image = UIImage(systemName: "square.and.pencil")
        return $0
    }(UIImageView(frame: CGRect(x: self.bounds.maxX - 28 - 18, y: self.bounds.minY + 12, width: 30, height: 30)))
    
    init(frame: CGRect, toDosCount: Int) {
        super.init(frame: frame)
        if toDosCount % 10 == 1 && toDosCount % 100 != 11 {
            countLabel.text = "\(toDosCount) Задачa"
        } else if (toDosCount % 10 == 2 || toDosCount % 10 == 3 || toDosCount % 10 == 4)
                    && toDosCount % 100 != 12 && toDosCount % 100 != 13 && toDosCount % 100 != 14 {
            countLabel.text = "\(toDosCount) Задачи"
        } else {
            countLabel.text = "\(toDosCount) Задач"
        }
        
        addSubview(footerView)
        addSubviews(countLabel, addButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
