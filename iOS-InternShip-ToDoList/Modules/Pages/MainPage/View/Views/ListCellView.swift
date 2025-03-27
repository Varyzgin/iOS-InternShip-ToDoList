//
//  ListCellView.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/19/25.
//

import UIKit

final class ListCellView: UITableViewCell {
    public static let id = "ListCellView"
    
    private lazy var data: ToDo? = nil
    
    private var screenWidth: CGFloat = 0
    private var contentWidth: CGFloat = 0
    private let checkoutButtonSize: CGSize = CGSize(width: 32, height: 32)

    private lazy var splitter: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    @objc private func checkoutButtonTapped() {
        if let data = self.data {
            if data.isDone {
                CoreManager.shared.updateToDo(id: data.id, isDone: !data.isDone)
                checkoutButton.image = UIImage(systemName: "circle")
                checkoutButton.tintColor = .inactive
            } else {
                CoreManager.shared.updateToDo(id: data.id, isDone: !data.isDone)
                checkoutButton.image = UIImage(systemName: "checkmark.circle")
                checkoutButton.tintColor = .accent
            }
        }
    }
    private lazy var checkoutButton: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(checkoutButtonTapped))
        imageView.addGestureRecognizer(gestureRecognizer)
        return imageView
    }()

//    private lazy var contentLayout: ContentMenuView = {
    private lazy var contentLayout: UIView = {
//        let view = ContentMenuView()
        let view = UIView()
        return view
    }()

    private lazy var striker: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryText
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = DynamicFont.set(textStyle: .headline)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = DynamicFont.set(textStyle: .body)
        label.numberOfLines = 2
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = DynamicFont.set(textStyle: .body)
        label.textColor = .secondaryText
        return label
    }()

    override func prepareForReuse() {
        super.prepareForReuse()

        checkoutButton.image = nil
        checkoutButton.tintColor = nil
        titleLabel.text = nil
        descriptionLabel.attributedText = nil
        descriptionLabel.text = nil
        descriptionLabel.attributedText = NSAttributedString(string: "", attributes: nil)
        dateLabel.text = nil
    }

    public func configure(with data: ToDo, isFirst: Bool = false, screenWidth: CGFloat) {
        self.data = data
        self.screenWidth = screenWidth
        self.contentWidth = screenWidth - 2 * Margins.M - Margins.XS - checkoutButtonSize.width
        
        // splitter
        if !isFirst {
            splitter.frame = CGRect(x: Margins.M, y: 1, width: screenWidth - 2 * Margins.M, height: 2)
            contentView.addSubview(splitter)
        } else {
            splitter.removeFromSuperview()
        }

        // button
        checkoutButton.image = UIImage(systemName: data.isDone ? "checkmark.circle" : "circle")
        checkoutButton.tintColor = data.isDone ? .accent : .inactive
        checkoutButton.frame = CGRect(x: Margins.M, y: Margins.S, width: checkoutButtonSize.width, height: checkoutButtonSize.height)
        contentView.addSubview(checkoutButton)

        // title
        titleLabel.text = data.title
        titleLabel.textColor = data.isDone ? .secondaryText : .primaryText
        titleLabel.frame = CGRect(x: 0, y: 0, width: contentWidth, height: 21)
        if data.isDone {
            striker.frame = CGRect(x: 0, y: titleLabel.frame.midY, width: ListCellView.calculateTextWidth(for: data.title, with: .preferredFont(forTextStyle: .headline), maxWidth: contentWidth), height: 2)
            titleLabel.addSubview(striker)
        } else {
            striker.removeFromSuperview()
        }
        contentLayout.addSubview(titleLabel)

        var yOffset = titleLabel.frame.maxY + Margins.XS

        // description
        if let text = data.descript {
            let textHeight = ListCellView.calculateTextHeight(for: text, with: UIFont.preferredFont(forTextStyle: .body), maxWidth: contentWidth, maxLines: 2)

            descriptionLabel.text = text
            descriptionLabel.textColor = data.isDone ? .secondaryText : .primaryText
            descriptionLabel.frame = CGRect(x: 0, y: yOffset, width: contentWidth, height: textHeight)
            contentLayout.addSubview(descriptionLabel)
            yOffset += textHeight + Margins.XS
        }

        // date
        dateLabel.text = data.date?.formattedDDMMYY()
        dateLabel.frame = CGRect(x: 0, y: yOffset, width: contentWidth, height: 17)
        contentLayout.addSubview(dateLabel)

        // contentLayout
        contentLayout.frame = CGRect(x: checkoutButton.frame.maxX + Margins.XS, y: Margins.S, width: contentWidth, height: yOffset + 17)
        contentView.addSubview(contentLayout)
    }

    public static func calculateTextHeight(for text: String, with font: UIFont, maxWidth: CGFloat, maxLines: Int = 2) -> CGFloat {
        let constraintSize = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(
            with: constraintSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        let textHeight = ceil(boundingBox.height)
        
        let boundingBoxWhole = "t".boundingRect(
            with: constraintSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        let oneLineHeight = ceil(boundingBoxWhole.height)
        let maxHeight: CGFloat = 2 * oneLineHeight

        return min(textHeight, maxHeight)
    }
    public static func calculateTextWidth(for text: String, with font: UIFont, maxWidth: CGFloat) -> CGFloat {
        let constraintSize = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(
            with: constraintSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return min(boundingBox.width, maxWidth)
    }
    static func calculateHeight(for data: ToDo, screenWidth: CGFloat) -> CGFloat {
        let contentWidth = screenWidth - 2 * Margins.M - Margins.XS - 32
        var height = Margins.S + 21 + Margins.XS // title + padding

        if let text = data.descript {
            height += calculateTextHeight(for: text, with: UIFont.preferredFont(forTextStyle: .body), maxWidth: contentWidth, maxLines: 2)
            height += Margins.XS
        }

        height += 17 + Margins.S // date + padding
        return height
    }
}


final class WholeCellView: UITableViewCell {
    public static let id = "WholeCellView"
    
    func configure(size: CGSize) {
        contentView.frame.size = size
    }
}
