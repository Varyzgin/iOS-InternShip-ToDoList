//
//  ListCellView.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/19/25.
//

import UIKit

final class ListCellView: UITableViewCell {
    public static let id = "ListCellView"
    
    private var screenWidth: CGFloat = 0
    private var contentWidth: CGFloat = 0
    private let checkoutButtonSize: CGSize = CGSize(width: 32, height: 32)

    private lazy var splitter: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()

    private lazy var checkoutButton: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var contentLayout: UIView = UIView()

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

//        checkoutButton.image = nil
//        checkoutButton.tintColor = nil
//        titleLabel.text = nil
//        descriptionLabel.text = nil
//        dateLabel.text = nil
    }

    public func configure(with data: ToDo, isFirst: Bool = false, screenWidth: CGFloat) {
        self.screenWidth = screenWidth
        self.contentWidth = screenWidth - 2 * Margins.M - Margins.XS - checkoutButtonSize.width
        
        // splitter
        if !isFirst {
            splitter.frame = CGRect(x: Margins.M, y: 1, width: screenWidth - 2 * Margins.M, height: 2)
            contentView.addSubview(splitter)
        }

        // button
        checkoutButton.image = UIImage(systemName: data.isDone ? "checkmark.circle" : "circle")
        checkoutButton.tintColor = data.isDone ? .accent : .inactive
        checkoutButton.frame = CGRect(x: Margins.M, y: Margins.S, width: checkoutButtonSize.width, height: checkoutButtonSize.height)
        contentView.addSubview(checkoutButton)

        // title
        //MARK: Выносим настройку атрибутов, так работает быстрее
        self.updateTitle(data.title, isDone: data.isDone)
        titleLabel.textColor = data.isDone ? .secondaryText : .primaryText
        titleLabel.frame = CGRect(x: 0, y: 0, width: contentWidth, height: 21)
        contentLayout.addSubview(titleLabel)

        var yOffset = titleLabel.frame.maxY + Margins.XS

        // description
        if let text = data.description {
            let textHeight = calculateTextHeight(for: text, width: contentWidth)
            descriptionLabel.text = text
            descriptionLabel.textColor = data.isDone ? .secondaryText : .primaryText
            descriptionLabel.frame = CGRect(x: 0, y: yOffset, width: contentWidth, height: textHeight)
            contentLayout.addSubview(descriptionLabel)
            yOffset += textHeight + Margins.XS
        }

        // date
        dateLabel.text = data.date
        dateLabel.frame = CGRect(x: 0, y: yOffset, width: contentWidth, height: 17)
        contentLayout.addSubview(dateLabel)

        // contentLayout
        contentLayout.frame = CGRect(x: checkoutButton.frame.maxX + Margins.XS, y: Margins.S, width: contentWidth, height: yOffset + 17)
        contentView.addSubview(contentLayout)
    }

    private func updateTitle(_ text: String, isDone: Bool) {
        if isDone {
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
            titleLabel.attributedText = attributedString
        } else {
            titleLabel.text = text
        }
    }
    
    private func calculateTextHeight(for text: String, width: CGFloat) -> CGFloat {
        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .body)]
        let boundingBox = text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
        return ceil(boundingBox.height)
    }

    static func calculateHeight(for data: ToDo, screenWidth: CGFloat) -> CGFloat {
        let contentWidth = screenWidth - 2 * Margins.M - Margins.XS - 32
        var height = Margins.S + 21 + Margins.XS // title + padding

        if let text = data.description {
            let maxSize = CGSize(width: contentWidth, height: .greatestFiniteMagnitude)
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .body)]
            let textHeight = text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil).height
            height += ceil(textHeight) + Margins.XS
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
