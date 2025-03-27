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
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = DynamicFont.set(textStyle: .largeTitle, trait: .traitBold)
        textView.isScrollEnabled = false
        textView.sizeToFit()
        
        textView.delegate = self
        
        return textView
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
        textView.font = DynamicFont.set(textStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.isScrollEnabled = false
        textView.sizeToFit()
        
        return textView
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let title = titleTextView.text {
            if let toDo = toDo {
                CoreManager.shared.updateToDo(id: toDo.id, title: title, descript: descriptionTextView.text, isDone: toDo.isDone)
            } else {
                CoreManager.shared.createToDo(title: title, descript: descriptionTextView.text, date: Date.now, isDone: false)
            }
        }
    }
    
    internal func configure(toDo: ToDo?) {
        navigationItem.largeTitleDisplayMode = .never
        
        if let toDo = toDo {
//            toDoID = id
//            print(toDo)
            self.toDo = toDo
            
            titleTextView.text = toDo.title
            titleTextView.textColor = .primaryText
            if let date = toDo.date {
                dateLabel.text = date.formattedDDMMYY()
            }
            if let descript = toDo.descript {
                descriptionTextView.text = descript
            }
            descriptionTextView.textColor = .primaryText
        } else {
            titleTextView.text = "Заголовок"
            titleTextView.textColor = .inactive
            dateLabel.text = "Date()."
            descriptionTextView.text = "Описание"
            descriptionTextView.textColor = .inactive

        }

        contentView.addSubviews(titleTextView, dateLabel, descriptionTextView)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        view.backgroundColor = .background
        setupConstraints()
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
            
            dateLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: Margins.XS),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Margins.XS),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Margins.S),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .inactive {
            textView.text = nil
            textView.textColor = .primaryText
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = .inactive
        }
    }
}
