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
    
    public var completion: (() -> Void)?
    
    @objc private func checkoutButtonTapped() {
        self.completion?()
    }
    
    private lazy var checkoutButton: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(checkoutButtonTapped))
        imageView.addGestureRecognizer(gestureRecognizer)
        return imageView
    }()

    internal lazy var contentLayout: ContentLayout = {
        let view = ContentLayout()
        return view
    }()

    override func prepareForReuse() {
        super.prepareForReuse()

        checkoutButton.image = nil
        checkoutButton.tintColor = nil
        
        contentLayout.resetContent()
    }

    public func configure(with data: ToDo, screenWidth: CGFloat) {
        self.data = data
        self.screenWidth = screenWidth
        self.contentWidth = screenWidth - 2 * Margins.M - Margins.XS - checkoutButtonSize.width
        
        // button
        checkoutButton.image = UIImage(systemName: data.isDone ? "checkmark.circle" : "circle")
        checkoutButton.tintColor = data.isDone ? .accent : .inactive
        checkoutButton.frame = CGRect(x: Margins.M, y: Margins.S, width: checkoutButtonSize.width, height: checkoutButtonSize.height)
        contentView.addSubview(checkoutButton)

        // contentLayout
        contentLayout.frame = CGRect(x: checkoutButton.frame.maxX + Margins.XS, y: Margins.S, width: contentWidth, height: frame.height - 2 * Margins.S)
        contentLayout.configure(with: data)
        contentView.addSubview(contentLayout)
    }
}
