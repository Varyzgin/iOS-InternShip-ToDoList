//
//  CGSize.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/27/25.
//

import UIKit

extension CGSize {
    public static func minSizeForTextInView(for text: String, with font: UIFont, maxWidth: CGFloat, maxLines: Int = 2) -> CGSize {
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
        let maxHeight: CGFloat = CGFloat(maxLines) * oneLineHeight

        return CGSize(width: min(boundingBox.width, maxWidth), height: min(textHeight, maxHeight))
    }
}
