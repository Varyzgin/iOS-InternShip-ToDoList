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
}
