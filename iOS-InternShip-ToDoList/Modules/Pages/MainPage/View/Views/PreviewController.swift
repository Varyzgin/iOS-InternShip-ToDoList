//
//  ContentMenuView.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/24/25.
//

import UIKit

final class PreviewController: UIViewController {
    private let snapshotView: UIView
    
    init(snapshot: UIView) {
        self.snapshotView = snapshot
        super.init(nibName: nil, bundle: nil)
        preferredContentSize = CGSize(width: snapshot.frame.size.width + 2 * Margins.S, height: snapshot.frame.size.height + 2 * Margins.S)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        snapshotView.frame.origin = CGPoint(x: Margins.S, y: Margins.S)
        view.addSubview(snapshotView)
    }
}
