//
//  ContentView.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/27/25.
//

import UIKit

final class ContentLayout: UIView {
    public lazy var striker: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryText
        return view
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = DynamicFont.set(textStyle: .headline)
        return label
    }()
    
    public lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = DynamicFont.set(textStyle: .body)
        label.numberOfLines = 2
        return label
    }()
    
    public lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = DynamicFont.set(textStyle: .body)
        label.textColor = .secondaryText
        return label
    }()
    
    public func configureIsDone() {
        titleLabel.textColor = .secondaryText
        striker.frame = CGRect(x: 0, y: titleLabel.frame.midY, width: ListCellView.calculateTextWidth(for: titleLabel.text!, with: .preferredFont(forTextStyle: .headline), maxWidth: self.frame.width), height: 2)
        titleLabel.addSubview(striker)
        if let text = descriptionLabel.text {
            descriptionLabel.textColor = .secondaryText
        }
    }
    
    public func configureIsNotDone() {
        titleLabel.textColor = .primaryText
        if let text = descriptionLabel.text {
            descriptionLabel.textColor = .primaryText
        }
    }
    
    init(frame: CGRect, data: ToDo) {
        super.init(frame: frame)
        
        // title
        titleLabel.text = data.title
        titleLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: 21)
        self.addSubview(titleLabel)

        var yOffset = titleLabel.frame.maxY + Margins.XS

        // description
        if let text = data.descript {
            let textHeight = ListCellView.calculateTextHeight(for: text, with: UIFont.preferredFont(forTextStyle: .body), maxWidth: frame.width, maxLines: 2)

            descriptionLabel.text = text
            descriptionLabel.frame = CGRect(x: 0, y: yOffset, width: frame.width, height: textHeight)
            self.addSubview(descriptionLabel)
            yOffset += textHeight + Margins.XS
        }

        // date
        dateLabel.text = data.date?.formattedDDMMYY()
        dateLabel.frame = CGRect(x: 0, y: yOffset, width: frame.width, height: 17)
        self.addSubview(dateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
