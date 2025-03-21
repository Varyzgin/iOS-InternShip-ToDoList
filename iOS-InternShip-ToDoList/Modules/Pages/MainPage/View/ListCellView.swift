//
//  ListCellView.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/19/25.
//

import UIKit

final class ListCellView: UITableViewCell {
    public static let id = "ListCellView"
    
    private lazy var screenWidth : CGFloat = 0
    private lazy var contentWidth : CGFloat = 0
    private lazy var dynamicBlockHeight : CGFloat = 0
    private lazy var checkoutButtonSize : CGSize = CGSize(width: 32, height: 32)
    
    private lazy var splitter: UIView = {
        $0.backgroundColor = .systemGray6
        return $0
    }(UIView(frame: CGRect(
        origin: CGPoint(x: Margins.M, y: 1),
        size: CGSize(width: screenWidth - 2 * Margins.M, height: 2))
    ))
    
    private lazy var checkoutButton: UIImageView = {
        $0.isUserInteractionEnabled = true
        return $0
    }(UIImageView(frame: CGRect(
        origin: CGPoint(x: Margins.M, y: Margins.S),
        size: checkoutButtonSize)
    ))

    private lazy var contentLayout : UIView = {
        return $0
    }(UIView(frame: CGRect(
        origin: CGPoint(x: checkoutButton.frame.maxX + Margins.XS, y: Margins.S),
        size: CGSize(width: contentWidth, height: contentView.bounds.height - 2 * Margins.S))
    ))

    private lazy var titleLabel: UILabel = {
        $0.font = DynamicFont.set(textStyle: .headline)
        return $0
    }(UILabel(frame: CGRect(
        origin: .zero,
        size: CGSize(width: contentWidth, height: 21))
    ))
    
    private lazy var descriptionLabel: UILabel = {
        $0.font = DynamicFont.set(textStyle: .body)
        $0.numberOfLines = 2
        return $0
    }(UILabel(frame: CGRect(
        origin: CGPoint(x: 0, y: titleLabel.frame.maxY + Margins.XS),
        size: CGSize(width: contentWidth, height: contentLayout.frame.height - titleLabel.frame.height - Margins.XS - Margins.XS - dateLabel.frame.height))
    ))

    private lazy var dateLabel: UILabel = {
        $0.font = DynamicFont.set(textStyle: .body)
        $0.textColor = .secondaryText
        return $0
    }(UILabel(frame: CGRect(
        origin: CGPoint(x: 0, y: contentLayout.bounds.maxY - 17),
        size: CGSize(width: contentWidth, height: 17))
    ))
    
    override func prepareForReuse() {
        checkoutButton.image = nil
        checkoutButton.tintColor = nil
//        contentLayout.frame = nil
        titleLabel.text = nil
        titleLabel.textColor = nil
        titleLabel.attributedText = nil
        descriptionLabel.text = nil
        descriptionLabel.textColor = nil
//        descriptionLabel.frame.size.height = 0
        dateLabel.text = nil
    }
    
    public func configure(with data: ToDo, isFirst: Bool = false, screenWidth: CGFloat) {
        self.screenWidth = screenWidth
        self.contentWidth = screenWidth - 2 * Margins.M - Margins.XS - checkoutButton.frame.width
        
        // splitter
        if !isFirst {
            contentView.addSubview(splitter)
        }
        
        // button
        checkoutButton.image = UIImage(systemName: data.isDone ? "checkmark.circle" : "circle")
        checkoutButton.tintColor = data.isDone ? .accent : .inactive
        contentView.addSubview(checkoutButton)
        
        // title
        let text = data.title
        if data.isDone {
            let attributedString = NSMutableAttributedString(string: text)

            attributedString.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSRange(location: 0, length: text.count)
            )
            titleLabel.attributedText = attributedString
        } else {
            titleLabel.text = text
        }
        titleLabel.textColor = data.isDone ? .secondaryText : .primaryText
        contentLayout.addSubview(titleLabel)
        
        // description
        if data.description != nil {
            descriptionLabel.text = data.description
            descriptionLabel.textColor = data.isDone ? .secondaryText : .primaryText
            contentLayout.addSubview(descriptionLabel)
        }
        
        // date
        dateLabel.text = data.date
        contentLayout.addSubview(dateLabel)
        
        // contentLayout
//        contentLayout.frame.size.height += titleLabel.frame.height + Margins.XS + dateLabel.frame.height
        contentView.addSubview(contentLayout)
    }
}

final class WholeCellView: UITableViewCell {
    public static let id = "WholeCellView"
    
    func configure(size: CGSize) {
        contentView.frame.size = size
    }
}
