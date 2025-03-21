//
//  DynamicFont.swift
//  iOS-InternShip-ToDoList
//
//  Created by Дима on 3/18/25.
//


import UIKit

final class DynamicFont: UIFont, @unchecked Sendable {
    public static func set(textStyle: UIFont.TextStyle, trait: UIFontDescriptor.SymbolicTraits? = nil) -> UIFont {
        let base = UIFont.preferredFont(forTextStyle: textStyle)
        if let trait = trait {
            return UIFont(descriptor: base.fontDescriptor.withSymbolicTraits(trait) ?? base.fontDescriptor, size: 0)
        }
        return UIFont(descriptor: base.fontDescriptor, size: 0)
    }

    public static func calculateTextHeight(for text: String, with font: UIFont, maxWidth: CGFloat, maxLines: Int = 2) -> CGFloat {
        let label = UILabel()
        label.font = font
        label.numberOfLines = maxLines
        label.lineBreakMode = .byTruncatingTail // Обрезаем текст, если он не помещается
        label.text = text

        // Рассчитываем размер с помощью sizeThatFits
        let constraintSize = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let size = label.sizeThatFits(constraintSize)

        // Возвращаем высоту
        return size.height + 10
    }
}
