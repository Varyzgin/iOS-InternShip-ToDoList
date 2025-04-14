//
//  ContentView.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/27/25.
//

import UIKit

final class ContentLayout: UIView {
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
    
    public func configureIfDone() {
        titleLabel.textColor = .secondaryText
        striker.frame = CGRect(x: 0, y: titleLabel.bounds.midY, width: CGSize.minSizeForTextInView(for: titleLabel.text!, with: .preferredFont(forTextStyle: .headline), maxWidth: self.bounds.width).width, height: 2)
        titleLabel.addSubview(striker)
        descriptionLabel.textColor = .secondaryText
    }
    
    public func configureIfNotDone() {
        titleLabel.textColor = .primaryText
        striker.removeFromSuperview()
        descriptionLabel.textColor = .primaryText
    }
    
    public func configure(with data: ToDo) {
        // text
        titleLabel.text = data.title
        if let text = data.descript { descriptionLabel.text = text }
        dateLabel.text = data.date?.formattedDDMMYY()

        // frames
        titleLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 21)
        dateLabel.frame = CGRect(x: 0, y: self.bounds.maxY - 17, width: self.bounds.width, height: 17)
        if let descript = data.descript, !descript.isEmpty { descriptionLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY + Margins.XS, width: self.bounds.width, height: dateLabel.frame.minY - titleLabel.frame.maxY - 2 * Margins.XS) }
        
        // colors
        if data.isDone { configureIfDone() } else { configureIfNotDone() }
        
        // adding
        self.addSubviews(titleLabel, dateLabel)
        if let descript = data.descript, !descript.isEmpty { self.addSubview(descriptionLabel) }
    }
    
    public func resetContent() {
        titleLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
    }
    
    public static func calculateFrame(for data: ToDo, screenWidth: CGFloat) -> CGSize {
        let contentWidth = screenWidth - 2 * Margins.M - Margins.XS - 32
        var height = Margins.S + 21 + Margins.XS // title + padding

        if let text = data.descript, !text.isEmpty {
            height += CGSize.minSizeForTextInView(for: text, with: UIFont.preferredFont(forTextStyle: .body), maxWidth: contentWidth, maxLines: 2).height
            height += Margins.XS
        }

        height += 17 + Margins.S // date + padding
        return CGSize(width: contentWidth, height: height)
    }
}
