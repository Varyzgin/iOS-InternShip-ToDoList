//
//  DetailsPageViewController.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/25/25.
//

import UIKit

final class DetailsPageViewController: UIViewController, UITextViewDelegate {
    private lazy var toDo: ToDo? = nil
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.tag = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = DynamicFont.set(textStyle: .largeTitle, trait: .traitBold)
        textView.textColor = .primaryText

        textView.isScrollEnabled = false
        textView.sizeToFit()
        
        textView.delegate = self
        
        return textView
    }()
    
    private lazy var titlePlaceHolderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DynamicFont.set(textStyle: .largeTitle, trait: .traitBold)
        label.text = "Название"
        label.textColor = .secondaryText
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryText
        label.font = DynamicFont.set(textStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.tag = 1
        textView.font = DynamicFont.set(textStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .primaryText
        
        textView.isScrollEnabled = false
        textView.sizeToFit()
        
        textView.delegate = self

        return textView
    }()
    
    private lazy var descriptionPlaceHolderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DynamicFont.set(textStyle: .body)
        label.text = "Описание"
        label.textColor = .secondaryText
        return label
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let title = titleTextView.text, !title.isEmpty {
            if let toDo = toDo { // если toDo == nil - то это значит, что заметки не было
                if self.toDo?.title != title || self.toDo?.descript != descriptionTextView.text {
                    CoreManager.shared.updateToDo(id: toDo.id, title: title, descript: descriptionTextView.text)
                }
            } else {
                CoreManager.shared.createToDo(title: title, descript: descriptionTextView.text)
            }
        }
    }
    
    internal func configure(toDo: ToDo?) {
        navigationItem.largeTitleDisplayMode = .never
        
        if let toDo = toDo {
            self.toDo = toDo
            
            titleTextView.text = toDo.title
            titlePlaceHolderLabel.isHidden = true
            if let date = toDo.date {
                dateLabel.text = date.formattedDDMMYY()
            }
            if let descript = toDo.descript, !descript.isEmpty {
                descriptionTextView.text = descript
                descriptionPlaceHolderLabel.isHidden = true
            }
        } else {
            dateLabel.text = Date.now.formattedDDMMYY()
        }

        contentView.addSubviews(titleTextView, dateLabel, descriptionTextView)
        contentView.addSubviews(titlePlaceHolderLabel, descriptionPlaceHolderLabel)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        view.backgroundColor = .background
        setupConstraints()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.tag == 0 {
            if textView.text == nil || textView.text.isEmpty {
                titlePlaceHolderLabel.isHidden = false
            } else {
                titlePlaceHolderLabel.isHidden = true
            }
        } else if textView.tag == 1 {
            if textView.text == nil || textView.text.isEmpty {
                descriptionPlaceHolderLabel.isHidden = false
            } else {
                descriptionPlaceHolderLabel.isHidden = true
            }
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * Margins.S),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Margins.S),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Margins.S),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            titleTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titlePlaceHolderLabel.centerYAnchor.constraint(equalTo: titleTextView.centerYAnchor),
            titlePlaceHolderLabel.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor, constant: Margins.XS),
            titlePlaceHolderLabel.trailingAnchor.constraint(equalTo: titleTextView.trailingAnchor, constant: -Margins.XS),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: Margins.XS),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Margins.XS),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Margins.S),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            descriptionPlaceHolderLabel.centerYAnchor.constraint(equalTo: descriptionTextView.centerYAnchor),
            descriptionPlaceHolderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: Margins.XS),
            descriptionPlaceHolderLabel.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor, constant: -Margins.XS),
        ])
    }
}
